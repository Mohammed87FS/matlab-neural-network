% TRAIN_TICTACTOE_MODEL - Train neural network on Tic Tac Toe
%
% This script trains a neural network to play Tic Tac Toe using training
% data generated from Cleve Moler's move generator.
%
% See also: NEURAL_NETWORK, TRAIN_TICTACTOE, GENERATE_TRAINING_DATA

clear; clc; close all;

fprintf('=========================================\n');
fprintf('Tic Tac Toe Neural Network Training\n');
fprintf('=========================================\n\n');

% Add paths - get script directory
script_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(script_dir, 'src'));
addpath(fullfile(script_dir, 'utils'));

%% 1. Generate Training Data
fprintf('1. Generating training data...\n');

num_games = 10000;  % Number of games to generate
move_generator_strategy = 'optimal';  % Use optimal strategy from Cleve Moler

[X, y] = generate_training_data(num_games, move_generator_strategy);

fprintf('   Training samples: %d\n', size(X, 1));
fprintf('   Features per sample: %d\n', size(X, 2));
fprintf('   Output classes: %d\n\n', size(y, 2));

%% 2. Split Data
fprintf('2. Splitting data (80%% train, 20%% test)...\n');

% Shuffle data
idx = randperm(size(X, 1));
X_shuffled = X(idx, :);
y_shuffled = y(idx, :);

% Split
split_idx = floor(0.8 * size(X, 1));
X_train = X_shuffled(1:split_idx, :);
y_train = y_shuffled(1:split_idx, :);
X_test = X_shuffled(split_idx+1:end, :);
y_test = y_shuffled(split_idx+1:end, :);

fprintf('   Training: %d samples\n', size(X_train, 1));
fprintf('   Test: %d samples\n\n', size(X_test, 1));

%% 3. Initialize Neural Network
fprintf('3. Initializing neural network...\n');

input_size = 9;   % 9 board positions
hidden_size = 64;  % Hidden layer neurons
output_size = 9;   % 9 possible moves

model = neural_network(input_size, hidden_size, output_size, ...
    'activation', 'relu', ...
    'output_activation', 'softmax');

fprintf('   Architecture: %d -> %d -> %d\n', input_size, hidden_size, output_size);
fprintf('   Activation: ReLU (hidden), Softmax (output)\n\n');

%% 4. Train Model
fprintf('4. Training model...\n\n');

options.num_epochs = 100;
options.learning_rate = 0.01;
options.batch_size = 32;
options.verbose = 10;  % Print every 10 epochs

[model, history] = train_tictactoe(X_train, y_train, model, options);

fprintf('\n   Training completed!\n\n');

%% 5. Evaluate Model
fprintf('5. Evaluating model...\n');

predictions = predict_tictactoe(model, X_test);

% Compute accuracy
[~, predicted_classes] = max(predictions, [], 2);
[~, true_classes] = max(y_test, [], 2);
accuracy = mean(predicted_classes == true_classes);

fprintf('\n   === Test Performance ===\n');
fprintf('   Accuracy: %.2f%%\n\n', accuracy * 100);

%% 6. Visualize Training History
fprintf('6. Visualizing training history...\n');

figure('Position', [100, 100, 1200, 400]);

% Loss
subplot(1, 2, 1);
plot(history.loss, 'LineWidth', 2);
xlabel('Epoch');
ylabel('Loss');
title('Training Loss');
grid on;

% Accuracy
subplot(1, 2, 2);
plot(history.accuracy * 100, 'LineWidth', 2);
xlabel('Epoch');
ylabel('Accuracy (%)');
title('Training Accuracy');
grid on;

fprintf('   ✓ Plots generated\n\n');

%% 7. Save Model
fprintf('7. Saving model...\n');

if ~exist('models', 'dir')
    mkdir('models');
end

save('models/tictactoe_model.mat', 'model', 'history', 'accuracy');
fprintf('   ✓ Model saved to: models/tictactoe_model.mat\n\n');

%% 8. Test Game Play
fprintf('8. Testing game play...\n');

% Play a test game
board = zeros(3, 3);
current_player = 1;

fprintf('\n   Test game (NN plays as X):\n');
display_board(board);

for turn = 1:9
    valid_moves = get_valid_moves(board);
    if isempty(valid_moves)
        break;
    end
    
    if current_player == 1
        % Neural network plays
        move = get_best_move(model, board, current_player);
        fprintf('   NN plays move %d\n', move);
    else
        % Opponent uses move generator
        move = move_generator(board, current_player, 'optimal');
        fprintf('   Opponent plays move %d\n', move);
    end
    
    [board, winner, game_over] = tictactoe_game(board, move, current_player);
    display_board(board);
    
    if game_over
        if winner == 1
            fprintf('   NN wins!\n');
        elseif winner == -1
            fprintf('   Opponent wins!\n');
        else
            fprintf('   Draw!\n');
        end
        break;
    end
    
    current_player = -current_player;
end

fprintf('\n=========================================\n');
fprintf('Training complete! ✓\n');
fprintf('=========================================\n\n');

fprintf('To play a game:\n');
fprintf('  load(''models/tictactoe_model.mat'', ''model'');\n');
fprintf('  play_tictactoe(model);\n\n');

