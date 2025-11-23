function move = get_best_move(model, board, player)
    % GET_BEST_MOVE - Get the best move from the neural network
    %
    % Syntax:
    %   move = get_best_move(model, board, player)
    %
    % Inputs:
    %   model  - Trained neural network model
    %   board  - 3x3 board matrix
    %   player - Current player (1 for X, -1 for O)
    %
    % Outputs:
    %   move   - Best move position (1-9)
    
    % Add paths - get function directory
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'src'));
    addpath(fullfile(func_dir, 'utils'));
    
    % Convert board to input vector
    board_vector = board_to_vector(board, player);
    
    % Get predictions
    predictions = predict_tictactoe(model, board_vector);
    
    % Get valid moves
    valid_moves = get_valid_moves(board);
    
    % Mask invalid moves (set probability to -inf)
    predictions_masked = predictions;
    invalid_moves = setdiff(1:9, valid_moves);
    predictions_masked(invalid_moves) = -inf;
    
    % Get move with highest probability
    [~, move] = max(predictions_masked);
end

