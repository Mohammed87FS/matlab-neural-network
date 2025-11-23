function vector = board_to_vector(board)
    % BOARD_TO_VECTOR - Convert 3x3 board matrix to feature vector
    %
    % Syntax:
    %   vector = board_to_vector(board)
    %
    % Inputs:
    %   board - 3x3 matrix where:
    %           +1 = player 1 (X)
    %           -1 = player 2 (O)
    %            0 = empty
    %
    % Outputs:
    %   vector - 9x1 feature vector (flattened board)
    %
    % Examples:
    %   board = [1 0 -1; 0 1 0; -1 0 0];
    %   vec = board_to_vector(board);
    
    if ~isequal(size(board), [3, 3])
        error('board_to_vector:InvalidSize', 'Board must be a 3x3 matrix');
    end
    
    % Flatten the board to a column vector
    vector = board(:);
end

