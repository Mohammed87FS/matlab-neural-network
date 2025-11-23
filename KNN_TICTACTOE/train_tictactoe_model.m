% TRAIN_TICTACTOE_MODEL - Main script to train a neural network for Tic Tac Toe
%
% This script:
%   1. Generates training data using Cleve Moler's move generator
%   2. Creates and trains a neural network
%   3. Saves the trained model
%
% Usage:
%   train_tictactoe_model

% Add paths
addpath(fullfile(fileparts(mfilename('fullpath')), 'utils'));
addpath(fullfile(fileparts(mfilename('fullpath')), 'src'));
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'NN_Car_Prices', 'src', 'utils'));

% Configuration
num_training_games = 5000;  % Number of games to generate for training
hidden_layer_size = 128;     % Number of neurons in hidden layer
num_epochs = 50;
learning_rate = 0.01;
batch_size = 32;
verbose_interval = 5;  % Print progress every N epochs

fprintf('=== Training Tic Tac Toe Neural Network ===\n\n');

% Step 1: Generate training data
fprintf('Step 1: Generating training data...\n');
[X_train, y_train] = generate_training_data(num_training_games, true);

% Step 2: Create neural network model
fprintf('\nStep 2: Creating neural network model...\n');
fprintf('  Input size: %d (board state)\n', size(X_train, 2));
fprintf('  Hidden layer size: %d\n', hidden_layer_size);
fprintf('  Output size: %d (possible moves)\n', size(y_train, 2));

model = neural_network(size(X_train, 2), hidden_layer_size, size(y_train, 2));

% Step 3: Set training options
fprintf('\nStep 3: Setting training options...\n');
options = struct();
options.num_epochs = num_epochs;
options.learning_rate = learning_rate;
options.batch_size = batch_size;
options.verbose = verbose_interval;

fprintf('  Epochs: %d\n', options.num_epochs);
fprintf('  Learning rate: %.4f\n', options.learning_rate);
fprintf('  Batch size: %d\n', options.batch_size);

% Step 4: Train the model
fprintf('\nStep 4: Training the model...\n');
[model, history] = train(X_train, y_train, model, options);

% Step 5: Save the model
fprintf('\nStep 5: Saving the model...\n');
if ~exist('models', 'dir')
    mkdir('models');
end

save('models/tictactoe_model.mat', 'model', 'history', 'options');
fprintf('  Model saved to: models/tictactoe_model.mat\n');

% Step 6: Plot training history
fprintf('\nStep 6: Plotting training history...\n');
figure;
subplot(2, 1, 1);
plot(1:num_epochs, history.loss);
xlabel('Epoch');
ylabel('Loss');
title('Training Loss');
grid on;

subplot(2, 1, 2);
plot(1:num_epochs, history.accuracy);
xlabel('Epoch');
ylabel('Accuracy');
title('Training Accuracy');
grid on;

fprintf('\n=== Training Complete ===\n');
fprintf('Final Loss: %.4f\n', history.loss(end));
fprintf('Final Accuracy: %.2f%%\n', history.accuracy(end) * 100);

