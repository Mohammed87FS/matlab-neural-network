function valid_moves = get_valid_moves(board)
    % GET_VALID_MOVES - Get list of valid move positions (1-9)
    valid_moves = find(board(:) == 0)';
end

