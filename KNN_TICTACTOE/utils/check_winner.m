function winner = check_winner(board)
    % CHECK_WINNER - Check if there's a winner
    % Returns: 1 (X wins), -1 (O wins), or [] (no winner yet)
    
    winner = [];
    
    % Check rows
    for i = 1:3
        if board(i, 1) == board(i, 2) && board(i, 2) == board(i, 3) && board(i, 1) ~= 0
            winner = board(i, 1);
            return;
        end
    end
    
    % Check columns
    for i = 1:3
        if board(1, i) == board(2, i) && board(2, i) == board(3, i) && board(1, i) ~= 0
            winner = board(1, i);
            return;
        end
    end
    
    % Check diagonals
    if board(1, 1) == board(2, 2) && board(2, 2) == board(3, 3) && board(1, 1) ~= 0
        winner = board(1, 1);
        return;
    end
    
    if board(1, 3) == board(2, 2) && board(2, 2) == board(3, 1) && board(1, 3) ~= 0
        winner = board(1, 3);
        return;
    end
end

