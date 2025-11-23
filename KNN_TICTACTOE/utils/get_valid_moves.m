function [rows, cols] = get_valid_moves(board)
    % GET_VALID_MOVES - Get all valid (empty) moves on the board
    %
    % Syntax:
    %   [rows, cols] = get_valid_moves(board)
    %
    % Inputs:
    %   board - 3x3 matrix where 0 indicates empty cells
    %
    % Outputs:
    %   rows - Row indices of valid moves
    %   cols - Column indices of valid moves
    
    [rows, cols] = find(board == 0);
end

