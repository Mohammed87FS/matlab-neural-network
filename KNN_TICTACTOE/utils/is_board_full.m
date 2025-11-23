function full = is_board_full(board)
    % IS_BOARD_FULL - Check if board is full
    full = all(board(:) ~= 0);
end

