function display_board(board)
    % DISPLAY_BOARD - Display the board in a readable format
    fprintf('\n');
    for i = 1:3
        for j = 1:3
            if board(i, j) == 1
                fprintf(' X ');
            elseif board(i, j) == -1
                fprintf(' O ');
            else
                fprintf(' . ');
            end
            if j < 3
                fprintf('|');
            end
        end
        fprintf('\n');
        if i < 3
            fprintf('-----------\n');
        end
    end
    fprintf('\n');
end

