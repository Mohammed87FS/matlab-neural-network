% EVALUATE_MODEL - Evaluate the trained Tic Tac Toe neural network
%
% This script evaluates the model by:
%   1. Playing games against Cleve Moler's strategy
%   2. Comparing performance
%
% Usage:
%   evaluate_model

% Add paths
addpath(fullfile(fileparts(mfilename('fullpath')), 'utils'));
addpath(fullfile(fileparts(mfilename('fullpath')), 'src'));
if ~exist('move_generator', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath'))));
end

% Load trained model
fprintf('Loading trained model...\n');
if ~exist('models/tictactoe_model.mat', 'file')
    error('Model not found. Please run train_tictactoe_model.m first.');
end

load('models/tictactoe_model.mat', 'model');

% Configuration
num_test_games = 100;

fprintf('=== Evaluating Tic Tac Toe Neural Network ===\n\n');
fprintf('Playing %d games against Cleve Moler strategy...\n', num_test_games);

results = struct();
results.nn_wins = 0;
results.strategy_wins = 0;
results.draws = 0;

for game = 1:num_test_games
    if mod(game, 20) == 0
        fprintf('  Game %d/%d\n', game, num_test_games);
    end
    
    % Initialize board
    board = zeros(3, 3);
    current_player = 1;  % NN plays as player 1 (X)
    
    % Play game
    while true
        % Check for winner
        winner = check_winner(board);
        if winner ~= 0
            if winner == 1
                results.nn_wins = results.nn_wins + 1;
            elseif winner == -1
                results.strategy_wins = results.strategy_wins + 1;
            else
                results.draws = results.draws + 1;
            end
            break
        end
        
        % Check if board is full
        if is_board_full(board)
            results.draws = results.draws + 1;
            break
        end
        
        % Make move
        if current_player == 1
            % Neural network's turn
            [i, j] = predict_tictactoe(model, board);
            if isempty(i)
                % No valid move, game ends in draw
                results.draws = results.draws + 1;
                break
            end
        else
            % Strategy's turn (Cleve Moler)
            [i, j] = move_generator(board, current_player);
            if isempty(i)
                % No valid move, game ends in draw
                results.draws = results.draws + 1;
                break
            end
        end
        
        board(i, j) = current_player;
        current_player = -current_player;
    end
end

% Print results
fprintf('\n=== Evaluation Results ===\n');
fprintf('Neural Network Wins: %d (%.1f%%)\n', results.nn_wins, ...
    100 * results.nn_wins / num_test_games);
fprintf('Strategy Wins: %d (%.1f%%)\n', results.strategy_wins, ...
    100 * results.strategy_wins / num_test_games);
fprintf('Draws: %d (%.1f%%)\n', results.draws, ...
    100 * results.draws / num_test_games);

