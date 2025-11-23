function [X, y] = generate_training_data(num_games, use_strategy)
    % GENERATE_TRAINING_DATA - Generate training data by playing Tic Tac Toe games
    %
    % Syntax:
    %   [X, y] = generate_training_data(num_games)
    %   [X, y] = generate_training_data(num_games, use_strategy)
    %
    % Inputs:
    %   num_games     - Number of games to play for training data
    %   use_strategy  - (Optional) If true, use Cleve Moler's strategy for both players
    %                   If false, use random moves for one player (default: true)
    %
    % Outputs:
    %   X - Training features (samples x 9), board states as vectors
    %   y - Training labels (samples x 9), one-hot encoded moves
    %
    % Each game generates multiple training samples (one per move)
    
    % Add paths
    if ~exist('board_to_vector', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath')), 'utils'));
    end
    if ~exist('move_generator', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath'))));
    end
    
    if nargin < 2
        use_strategy = true;
    end
    
    X = [];
    y = [];
    
    fprintf('Generating training data from %d games...\n', num_games);
    
    for game = 1:num_games
        if mod(game, 100) == 0
            fprintf('  Game %d/%d\n', game, num_games);
        end
        
        % Initialize empty board
        board = zeros(3, 3);
        current_player = 1;  % Player 1 (X) starts
        
        % Play until game ends
        while true
            % Check for winner or draw
            winner = check_winner(board);
            if winner ~= 0
                break
            end
            
            % Get valid moves
            [valid_rows, valid_cols] = get_valid_moves(board);
            if isempty(valid_rows)
                break
            end
            
            % Generate move
            if use_strategy || current_player == 1
                % Use strategy for player 1, or for both if use_strategy is true
                [i, j] = move_generator(board, current_player);
            else
                % Random move for player 2 if not using strategy
                move_idx = ceil(rand * length(valid_rows));
                i = valid_rows(move_idx);
                j = valid_cols(move_idx);
            end
            
            % Store training sample
            board_vector = board_to_vector(board);
            X = [X; board_vector'];
            
            % Create one-hot encoded move (position in flattened board)
            move_vector = zeros(1, 9);
            move_idx = (i - 1) * 3 + j;  % Convert (i,j) to linear index
            move_vector(move_idx) = 1;
            y = [y; move_vector];
            
            % Make the move
            board(i, j) = current_player;
            
            % Switch player
            current_player = -current_player;
        end
    end
    
    fprintf('Generated %d training samples\n', size(X, 1));
end

