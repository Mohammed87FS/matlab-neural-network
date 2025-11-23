function [board, winner, game_over] = tictactoe_game(board, move, player)
    % TICTACTOE_GAME - Play a move in Tic Tac Toe and check game state
    %
    % Syntax:
    %   [board, winner, game_over] = tictactoe_game(board, move, player)
    %
    % Inputs:
    %   board  - 3x3 board matrix (0=empty, 1=X, -1=O)
    %   move   - Move position (1-9, row-major order)
    %   player - Player making the move (1 for X, -1 for O)
    %
    % Outputs:
    %   board     - Updated board after move
    %   winner    - Winner: 1 (X wins), -1 (O wins), 0 (draw), [] (game continues)
    %   game_over - Boolean indicating if game is finished
    %
    % Example:
    %   board = zeros(3, 3);
    %   [board, winner, game_over] = tictactoe_game(board, 5, 1);  % X plays center
    
    % Add utils path - get function directory
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'utils'));
    
    % Convert move (1-9) to row, col indices
    row = floor((move - 1) / 3) + 1;
    col = mod(move - 1, 3) + 1;
    
    % Check if move is valid
    if board(row, col) ~= 0
        error('tictactoe_game:InvalidMove', 'Position %d is already occupied', move);
    end
    
    % Make the move
    board(row, col) = player;
    
    % Check for winner
    winner = check_winner(board);
    game_over = ~isempty(winner) || is_board_full(board);
    
    if game_over && isempty(winner)
        winner = 0;  % Draw
    end
end

