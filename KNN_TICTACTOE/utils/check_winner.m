function p = check_winner(board)
    % CHECK_WINNER - Check if there is a winner in the Tic Tac Toe board
    %
    % Syntax:
    %   p = check_winner(board)
    %
    % Inputs:
    %   board - 3x3 matrix where:
    %           +1 = player 1 (X)
    %           -1 = player 2 (O)
    %            0 = empty
    %
    % Outputs:
    %   p = 0, no winner yet
    %   p = -1, player 2 (O) has won
    %   p = 1, player 1 (X) has won
    %   p = 2, game is a draw (board full, no winner)
    %
    % Based on Cleve Moler's winner function from TicTacToe Magic
    
    for p = [-1 1]
        s = 3 * p;
        win = any(sum(board) == s) || any(sum(board') == s) || ...
              sum(diag(board)) == s || sum(diag(fliplr(board))) == s;
        if win
            return
        end
    end
    
    % Check for draw (board full, no winner)
    p = 2 * all(board(:) ~= 0);
end

