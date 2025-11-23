function full = is_board_full(board)
    % IS_BOARD_FULL - Check if the board is completely filled
    %
    % Syntax:
    %   full = is_board_full(board)
    %
    % Inputs:
    %   board - 3x3 matrix
    %
    % Outputs:
    %   full - true if board is full, false otherwise
    
    full = all(board(:) ~= 0);
end

