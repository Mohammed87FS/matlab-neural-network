function evaluate_model(model, num_games)
    % Add paths - get function directory
    func_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(func_dir, 'src'));
    addpath(fullfile(func_dir, 'utils'));
    % EVALUATE_MODEL - Evaluate neural network performance against move generator
    %
    % Syntax:
    %   evaluate_model(model, num_games)
    %
    % Inputs:
    %   model     - Trained neural network model (optional, loads from file if not provided)
    %   num_games - Number of games to play for evaluation (default: 100)
    %
    % This function plays games between the neural network and the move generator
    % and reports win/loss/draw statistics.
    
    % Load model if not provided
    if nargin < 1 || isempty(model)
        if exist('models/tictactoe_model.mat', 'file')
            load('models/tictactoe_model.mat', 'model');
        else
            error('evaluate_model:NoModel', ...
                'No model provided and models/tictactoe_model.mat not found.');
        end
    end
    
    if nargin < 2
        num_games = 100;
    end
    
    fprintf('=========================================\n');
    fprintf('Evaluating Neural Network Model\n');
    fprintf('=========================================\n\n');
    fprintf('Playing %d games against optimal move generator...\n\n', num_games);
    
    nn_wins = 0;
    opponent_wins = 0;
    draws = 0;
    
    for game = 1:num_games
        board = zeros(3, 3);
        current_player = 1;  % NN plays as X
        
        while true
            valid_moves = get_valid_moves(board);
            if isempty(valid_moves)
                draws = draws + 1;
                break;
            end
            
            if current_player == 1
                % Neural network plays
                move = get_best_move(model, board, current_player);
            else
                % Opponent uses move generator
                move = move_generator(board, current_player, 'optimal');
            end
            
            [board, winner, game_over] = tictactoe_game(board, move, current_player);
            
            if game_over
                if winner == 1
                    nn_wins = nn_wins + 1;
                elseif winner == -1
                    opponent_wins = opponent_wins + 1;
                else
                    draws = draws + 1;
                end
                break;
            end
            
            current_player = -current_player;
        end
        
        % Progress indicator
        if mod(game, max(1, floor(num_games/10))) == 0
            fprintf('  Progress: %d/%d games\n', game, num_games);
        end
    end
    
    fprintf('\n=========================================\n');
    fprintf('Evaluation Results\n');
    fprintf('=========================================\n');
    fprintf('Neural Network Wins:  %d (%.1f%%)\n', nn_wins, 100*nn_wins/num_games);
    fprintf('Opponent Wins:        %d (%.1f%%)\n', opponent_wins, 100*opponent_wins/num_games);
    fprintf('Draws:                %d (%.1f%%)\n', draws, 100*draws/num_games);
    fprintf('=========================================\n\n');
end

