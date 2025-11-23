function play_tictactoe(model)
    % Add paths - get function directory
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'src'));
    addpath(fullfile(func_dir, 'utils'));
    % PLAY_TICTACTOE - Interactive Tic Tac Toe game with neural network
    %
    % Syntax:
    %   play_tictactoe(model)
    %
    % Inputs:
    %   model - Trained neural network model (optional, loads from file if not provided)
    %
    % Example:
    %   load('models/tictactoe_model.mat', 'model');
    %   play_tictactoe(model);
    
    % Load model if not provided
    if nargin < 1
        if exist('models/tictactoe_model.mat', 'file')
            load('models/tictactoe_model.mat', 'model');
            fprintf('Model loaded from models/tictactoe_model.mat\n\n');
        else
            error('play_tictactoe:NoModel', ...
                'No model provided and models/tictactoe_model.mat not found. Train the model first.');
        end
    end
    
    fprintf('=========================================\n');
    fprintf('Tic Tac Toe - Play against Neural Network\n');
    fprintf('=========================================\n\n');
    fprintf('You are O, Neural Network is X\n');
    fprintf('Enter moves as numbers 1-9 (row-major order):\n');
    fprintf('  1 | 2 | 3\n');
    fprintf('  ---------\n');
    fprintf('  4 | 5 | 6\n');
    fprintf('  ---------\n');
    fprintf('  7 | 8 | 9\n\n');
    
    % Initialize game
    board = zeros(3, 3);
    current_player = 1;  % X (NN) starts
    
    while true
        display_board(board);
        
        % Check for game over
        winner = check_winner(board);
        if ~isempty(winner)
            if winner == 1
                fprintf('Neural Network (X) wins!\n');
            elseif winner == -1
                fprintf('You (O) win!\n');
            end
            break;
        end
        
        if is_board_full(board)
            fprintf('Draw!\n');
            break;
        end
        
        if current_player == 1
            % Neural Network's turn
            fprintf('Neural Network is thinking...\n');
            valid_moves = get_valid_moves(board);
            if isempty(valid_moves)
                break;
            end
            
            move = get_best_move(model, board, current_player);
            fprintf('Neural Network plays move %d\n\n', move);
            
            [board, winner, game_over] = tictactoe_game(board, move, current_player);
            
            if game_over
                display_board(board);
                if winner == 1
                    fprintf('Neural Network (X) wins!\n');
                elseif winner == -1
                    fprintf('You (O) win!\n');
                else
                    fprintf('Draw!\n');
                end
                break;
            end
            
            current_player = -current_player;
            
        else
            % Human player's turn
            valid_moves = get_valid_moves(board);
            fprintf('Your turn (O). Valid moves: ');
            fprintf('%d ', valid_moves);
            fprintf('\n');
            
            move = input('Enter your move (1-9): ');
            
            % Validate move
            if ~ismember(move, valid_moves)
                fprintf('Invalid move! Please try again.\n\n');
                continue;
            end
            
            [board, winner, game_over] = tictactoe_game(board, move, current_player);
            
            if game_over
                display_board(board);
                if winner == 1
                    fprintf('Neural Network (X) wins!\n');
                elseif winner == -1
                    fprintf('You (O) win!\n');
                else
                    fprintf('Draw!\n');
                end
                break;
            end
            
            current_player = -current_player;
        end
    end
    
    fprintf('\nThanks for playing!\n');
end

