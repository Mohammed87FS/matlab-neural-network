function board_flat = board_to_vector(board, player)
    % BOARD_TO_VECTOR - Convert board to input vector for neural network
    % Returns: 9-element vector where:
    %   1 = current player's piece
    %   -1 = opponent's piece
    %   0 = empty
    %
    % Inputs:
    %   board  - 3x3 board matrix
    %   player - Current player (1 for X, -1 for O)
    
    board_flat = board(:)';
    
    % Normalize: multiply by player to get perspective
    % If player is O (-1), flip the board perspective
    board_flat = board_flat * player;
end

