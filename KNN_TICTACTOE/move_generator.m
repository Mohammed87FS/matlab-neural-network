function [i, j] = move_generator(board, player)
    % MOVE_GENERATOR - Generate a move using Cleve Moler's strategy
    %
    % Syntax:
    %   [i, j] = move_generator(board, player)
    %
    % Inputs:
    %   board  - 3x3 matrix where:
    %            +1 = player 1 (X)
    %            -1 = player 2 (O)
    %             0 = empty
    %   player - Player making the move (+1 for X, -1 for O)
    %
    % Outputs:
    %   i, j   - Row and column indices for the move
    %
    % Strategy (based on Cleve Moler's TicTacToe Magic):
    %   1. If possible, make a winning move
    %   2. If necessary, block a possible winning move by the opponent
    %   3. Otherwise, pick a random empty square
    %
    % See also: WINNING_MOVE
    
    % Add path to utils
    if ~exist('get_valid_moves', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath')), 'utils'));
    end
    
    % If possible, make a winning move
    [i, j] = winning_move(board, player);
    
    % Block any winning move by opponent
    if isempty(i)
        [i, j] = winning_move(board, -player);
    end
    
    % Otherwise, make a random move
    if isempty(i)
        [rows, cols] = get_valid_moves(board);
        if ~isempty(rows)
            m = ceil(rand * length(rows));
            i = rows(m);
            j = cols(m);
        else
            i = [];
            j = [];
        end
    end
end

function [i, j] = winning_move(board, player)
    % WINNING_MOVE - Find a winning move for the given player
    %
    % Syntax:
    %   [i, j] = winning_move(board, player)
    %
    % Inputs:
    %   board  - 3x3 matrix
    %   player - Player (+1 or -1)
    %
    % Outputs:
    %   i, j   - Row and column indices for winning move, or [] if none
    
    s = 2 * player;
    
    % Check columns
    if any(sum(board) == s)
        j = find(sum(board) == s);
        j = j(1);  % Take first matching column
        i = find(board(:, j) == 0);
        if ~isempty(i)
            i = i(1);
            return
        end
    end
    
    % Check rows
    if any(sum(board') == s)
        i = find(sum(board') == s);
        i = i(1);  % Take first matching row
        j = find(board(i, :) == 0);
        if ~isempty(j)
            j = j(1);
            return
        end
    end
    
    % Check main diagonal
    if sum(diag(board)) == s
        diag_indices = find(diag(board) == 0);
        if ~isempty(diag_indices)
            i = diag_indices(1);
            j = i;
            return
        end
    end
    
    % Check anti-diagonal
    if sum(diag(fliplr(board))) == s
        anti_diag_indices = find(diag(fliplr(board)) == 0);
        if ~isempty(anti_diag_indices)
            i = anti_diag_indices(1);
            j = 4 - i;
            return
        end
    end
    
    % No winning move found
    i = [];
    j = [];
end

