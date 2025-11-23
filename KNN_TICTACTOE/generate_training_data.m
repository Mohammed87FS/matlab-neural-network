function [X, y] = generate_training_data(num_games, move_generator_strategy)
    % Add utils path - get function directory
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'utils'));
    % GENERATE_TRAINING_DATA - Generate training data by playing Tic Tac Toe games
    %
    % Syntax:
    %   [X, y] = generate_training_data(num_games, move_generator_strategy)
    %
    % Inputs:
    %   num_games              - Number of games to generate
    %   move_generator_strategy - Strategy for move generator: 'optimal', 'random', etc.
    %
    % Outputs:
    %   X - Training features (samples x 9) - board states
    %   y - Training labels (samples x 9) - one-hot encoded moves
    %
    % This function plays games using the move generator and collects
    % board states with their corresponding optimal moves as training data.
    
    if nargin < 2
        move_generator_strategy = 'optimal';
    end
    
    fprintf('Generating training data from %d games...\n', num_games);
    
    X = [];
    y = [];
    
    for game = 1:num_games
        % Initialize game
        board = zeros(3, 3);
        current_player = 1;  % X starts
        
        % Play game
        while true
            % Get valid moves
            valid_moves = get_valid_moves(board);
            
            if isempty(valid_moves)
                break;
            end
            
            % Ensure valid_moves is a row vector
            valid_moves = valid_moves(:)';
            
            % Store board state before calling move_generator (safety check)
            board_before = board;
            
            % Generate move using move generator
            move = move_generator(board, current_player, move_generator_strategy);
            
            % Verify board hasn't changed (it shouldn't, but check anyway)
            if ~isequal(board, board_before)
                warning('Board changed during move generation, skipping this game');
                break;
            end
            
            % Validate move before proceeding - double check it's valid
            if ~isscalar(move) || move < 1 || move > 9
                warning('Invalid move %d generated (not scalar or out of range), skipping this game', move);
                break;
            end
            
            % Re-compute valid_moves to ensure we have the latest state
            valid_moves_current = [];
            for pos = 1:9
                row = floor((pos - 1) / 3) + 1;
                col = mod(pos - 1, 3) + 1;
                if board(row, col) == 0
                    valid_moves_current = [valid_moves_current, pos];
                end
            end
            
            if ~ismember(move, valid_moves_current)
                warning('Move %d not in valid moves, skipping this game', move);
                break;
            end
            
            % Final check: ensure the position is actually empty
            row = floor((move - 1) / 3) + 1;
            col = mod(move - 1, 3) + 1;
            if board(row, col) ~= 0
                warning('Position %d is already occupied, skipping this game', move);
                break;
            end
            
            % Convert board to input vector (from current player's perspective)
            board_vector = board_to_vector(board, current_player);
            
            % Create one-hot encoded label for the move
            move_label = zeros(1, 9);
            move_label(move) = 1;
            
            % Store training sample
            X = [X; board_vector];
            y = [y; move_label];
            
            % Make the move
            [board, winner, game_over] = tictactoe_game(board, move, current_player);
            
            if game_over
                break;
            end
            
            % Switch player
            current_player = -current_player;
        end
        
        % Progress indicator
        if mod(game, max(1, floor(num_games/10))) == 0
            fprintf('  Progress: %d/%d games (%.1f%%)\n', game, num_games, 100*game/num_games);
        end
    end
    
    fprintf('Generated %d training samples from %d games\n', size(X, 1), num_games);
end

