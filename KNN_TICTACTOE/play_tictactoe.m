% PLAY_TICTACTOE - Interactive Tic Tac Toe game against the neural network
%
% Usage:
%   play_tictactoe

% Add paths
addpath(fullfile(fileparts(mfilename('fullpath')), 'utils'));
addpath(fullfile(fileparts(mfilename('fullpath')), 'src'));
if ~exist('predict_tictactoe', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath'))));
end

% Load trained model
fprintf('Loading trained model...\n');
if ~exist('models/tictactoe_model.mat', 'file')
    error('Model not found. Please run train_tictactoe_model.m first.');
end

load('models/tictactoe_model.mat', 'model');

fprintf('=== Tic Tac Toe Game ===\n');
fprintf('You are O, Neural Network is X\n');
fprintf('Enter moves as row,col (e.g., 1,2 for row 1, column 2)\n\n');

% Initialize board
board = zeros(3, 3);
current_player = 1;  % NN starts (X)

while true
    % Display board
    display_board(board);
    
    % Check for winner
    winner = check_winner(board);
    if winner == 1
        fprintf('Neural Network (X) wins!\n');
        break
    elseif winner == -1
        fprintf('You (O) win!\n');
        break
    elseif winner == 2
        fprintf('It''s a draw!\n');
        break
    end
    
    if current_player == 1
        % Neural network's turn
        fprintf('Neural Network is thinking...\n');
        [i, j] = predict_tictactoe(model, board);
        if isempty(i)
            fprintf('No valid moves. Game ends in draw.\n');
            break
        end
        board(i, j) = 1;
        fprintf('Neural Network plays: (%d, %d)\n', i, j);
        current_player = -1;
    else
        % Human player's turn
        fprintf('Your turn (O). Enter move as row,col: ');
        move = input('', 's');
        
        % Parse input
        parts = strsplit(move, ',');
        if length(parts) ~= 2
            fprintf('Invalid format. Please use row,col (e.g., 1,2)\n');
            continue
        end
        
        i = str2double(parts{1});
        j = str2double(parts{2});
        
        % Validate move
        if isnan(i) || isnan(j) || i < 1 || i > 3 || j < 1 || j > 3
            fprintf('Invalid move. Row and column must be between 1 and 3.\n');
            continue
        end
        
        if board(i, j) ~= 0
            fprintf('That cell is already occupied. Try again.\n');
            continue
        end
        
        board(i, j) = -1;
        current_player = 1;
    end
end

display_board(board);

