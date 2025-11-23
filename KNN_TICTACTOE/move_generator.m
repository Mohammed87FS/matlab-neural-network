function move = move_generator(board, player, strategy)
    % MOVE_GENERATOR - Generate moves based on Cleve Moler's strategy
    %
    % Syntax:
    %   move = move_generator(board, player, strategy)
    %
    % Inputs:
    %   board    - 3x3 board matrix (0=empty, 1=X, -1=O)
    %   player   - Current player (1 for X, -1 for O)
    %   strategy - Strategy type: 'optimal', 'random', 'defensive', 'aggressive'
    %
    % Outputs:
    %   move     - Move position (1-9)
    %
    % This implements Cleve Moler's tic-tac-toe strategy with multiple levels:
    % 1. Win if possible
    % 2. Block opponent from winning
    % 3. Take center if available
    % 4. Take corner if available
    % 5. Take edge if available
    % 6. Random move
    
    % Add utils path - get function directory
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'utils'));
    
    if nargin < 3
        strategy = 'optimal';
    end
    
    % Get valid moves - compute directly from board to ensure accuracy
    valid_moves = [];
    for pos = 1:9
        row = floor((pos - 1) / 3) + 1;
        col = mod(pos - 1, 3) + 1;
        if board(row, col) == 0
            valid_moves = [valid_moves, pos];
        end
    end
    
    if isempty(valid_moves)
        error('move_generator:NoMoves', 'No valid moves available');
    end
    
    % Try to get a strategic move
    move_candidate = [];
    try
        switch lower(strategy)
            case 'optimal'
                move_candidate = optimal_move(board, player, valid_moves);
            case 'random'
                move_candidate = valid_moves(randi(length(valid_moves)));
            case 'defensive'
                move_candidate = defensive_move(board, player, valid_moves);
            case 'aggressive'
                move_candidate = aggressive_move(board, player, valid_moves);
            otherwise
                move_candidate = optimal_move(board, player, valid_moves);
        end
    catch
        % If anything goes wrong, use random
        move_candidate = [];
    end
    
    % Validate the candidate move
    if isempty(move_candidate) || ~isscalar(move_candidate) || move_candidate < 1 || move_candidate > 9
        move = valid_moves(randi(length(valid_moves)));
    elseif ~ismember(move_candidate, valid_moves)
        move = valid_moves(randi(length(valid_moves)));
    else
        % Double-check the position is actually empty
        row = floor((move_candidate - 1) / 3) + 1;
        col = mod(move_candidate - 1, 3) + 1;
        if board(row, col) == 0
            move = move_candidate;
        else
            move = valid_moves(randi(length(valid_moves)));
        end
    end
    
    % Final safety check - ensure move is valid
    row = floor((move - 1) / 3) + 1;
    col = mod(move - 1, 3) + 1;
    if board(row, col) ~= 0
        % Find first valid move as last resort
        for m = valid_moves
            row = floor((m - 1) / 3) + 1;
            col = mod(m - 1, 3) + 1;
            if board(row, col) == 0
                move = m;
                break;
            end
        end
    end
end

function move = optimal_move(board, player, valid_moves)
    % OPTIMAL_MOVE - Cleve Moler's optimal strategy
    
    % Ensure check_winner is available
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'utils'));
    
    % 1. Win if possible
    move = find_winning_move(board, player, valid_moves);
    if ~isempty(move) && ismember(move, valid_moves)
        return;
    end
    
    % 2. Block opponent from winning
    move = find_winning_move(board, -player, valid_moves);
    if ~isempty(move) && ismember(move, valid_moves)
        return;
    end
    
    % 3. Take center if available
    if ismember(5, valid_moves)
        move = 5;
        return;
    end
    
    % 4. Take corner if available
    corners = [1, 3, 7, 9];
    available_corners = intersect(corners, valid_moves);
    if ~isempty(available_corners)
        move = available_corners(randi(length(available_corners)));
        return;
    end
    
    % 5. Take edge if available
    edges = [2, 4, 6, 8];
    available_edges = intersect(edges, valid_moves);
    if ~isempty(available_edges)
        move = available_edges(randi(length(available_edges)));
        return;
    end
    
    % 6. Random move (shouldn't happen, but just in case)
    move = valid_moves(randi(length(valid_moves)));
end

function move = find_winning_move(board, player, valid_moves)
    % FIND_WINNING_MOVE - Check if player can win with a single move
    % Utils path already added in parent function
    
    move = [];
    
    % Ensure check_winner is available
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'utils'));
    
    % Ensure valid_moves is a row vector
    valid_moves = valid_moves(:)';
    
    for i = 1:length(valid_moves)
        m = valid_moves(i);
        
        % Double-check this move is still valid
        row = floor((m - 1) / 3) + 1;
        col = mod(m - 1, 3) + 1;
        if board(row, col) ~= 0
            continue;  % Skip if position is already occupied
        end
        
        % Try the move
        test_board = board;
        test_board(row, col) = player;
        
        % Check if this move wins
        winner = check_winner(test_board);
        if winner == player
            move = m;
            return;
        end
    end
end

function move = defensive_move(board, player, valid_moves)
    % DEFENSIVE_MOVE - Prioritize blocking opponent
    
    % Ensure check_winner is available
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'utils'));
    
    % 1. Block opponent from winning
    move = find_winning_move(board, -player, valid_moves);
    if ~isempty(move) && ismember(move, valid_moves)
        return;
    end
    
    % 2. Win if possible
    move = find_winning_move(board, player, valid_moves);
    if ~isempty(move) && ismember(move, valid_moves)
        return;
    end
    
    % 3. Random move
    move = valid_moves(randi(length(valid_moves)));
end

function move = aggressive_move(board, player, valid_moves)
    % AGGRESSIVE_MOVE - Prioritize winning
    
    % Ensure check_winner is available
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'utils'));
    
    % 1. Win if possible
    move = find_winning_move(board, player, valid_moves);
    if ~isempty(move) && ismember(move, valid_moves)
        return;
    end
    
    % 2. Block opponent from winning
    move = find_winning_move(board, -player, valid_moves);
    if ~isempty(move) && ismember(move, valid_moves)
        return;
    end
    
    % 3. Random move
    move = valid_moves(randi(length(valid_moves)));
end

% Helper functions moved to utils/game_utils.m

