function [i, j] = predict_tictactoe(model, board)
    % PREDICT_TICTACTOE - Predict the best move for a given board state
    %
    % Syntax:
    %   [i, j] = predict_tictactoe(model, board)
    %
    % Inputs:
    %   model - Trained neural network model
    %   board - 3x3 matrix representing the current board state
    %
    % Outputs:
    %   i, j  - Row and column indices for the predicted move
    %
    % The function selects the move with highest probability among valid moves
    
    % Add paths
    if ~exist('board_to_vector', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath')), 'utils'));
    end
    if ~exist('get_valid_moves', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath')), 'utils'));
    end
    if ~exist('predict', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath')), 'src'));
    end
    
    % Convert board to feature vector
    board_vec = board_to_vector(board);
    
    % Get predictions
    predictions = predict(model, board_vec');
    
    % Get valid moves
    [valid_rows, valid_cols] = get_valid_moves(board);
    
    if isempty(valid_rows)
        i = [];
        j = [];
        return
    end
    
    % Convert valid moves to linear indices
    valid_indices = (valid_rows - 1) * 3 + valid_cols;
    
    % Get probabilities for valid moves only
    % predictions is (1 x 9) for a single sample
    if size(predictions, 1) == 1
        valid_probs = predictions(valid_indices);
    else
        valid_probs = predictions(1, valid_indices);
    end
    
    % Find the move with highest probability
    [~, best_idx] = max(valid_probs);
    
    % Convert back to (i, j) coordinates
    i = valid_rows(best_idx);
    j = valid_cols(best_idx);
end

