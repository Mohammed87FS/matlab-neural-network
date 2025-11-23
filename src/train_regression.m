function [model, history] = train_regression(X, y, model, options)
    % TRAIN_REGRESSION - Train a neural network for regression tasks
    %
    % Syntax:
    %   [model, history] = train_regression(X, y, model, options)
    %
    % Inputs:
    %   X       - Training data matrix (samples x features)
    %   y       - Target values (samples x 1)
    %   model   - Neural network model structure
    %   options - Training options structure with fields:
    %             .num_epochs (number of training epochs)
    %             .learning_rate (learning rate for gradient descent)
    %             .batch_size (mini-batch size)
    %             .verbose (print progress every N epochs)
    %
    % Outputs:
    %   model   - Trained model
    %   history - Training history with loss values
    %
    % See also: NEURAL_NETWORK_REGRESSION, TRAIN
    
    % Validate inputs
    if nargin < 4
        error('train_regression:NotEnoughInputs', ...
            'Requires 4 inputs: X, y, model, options');
    end
    
    % Extract options
    num_epochs = options.num_epochs;
    learning_rate = options.learning_rate;
    batch_size = options.batch_size;
    verbose = options.verbose;
    
    % Initialize history
    history.loss = zeros(num_epochs, 1);
    history.mae = zeros(num_epochs, 1);
    
    % Training loop
    for epoch = 1:num_epochs
        % Shuffle the data
        idx = randperm(size(X, 1));
        X_shuffled = X(idx, :);
        y_shuffled = y(idx);
        
        epoch_loss = 0;
        num_batches = 0;
        
        % Mini-batch training
        for i = 1:batch_size:size(X, 1)
            % Get mini-batch
            batch_end = min(i + batch_size - 1, size(X, 1));
            X_batch = X_shuffled(i:batch_end, :);
            y_batch = y_shuffled(i:batch_end);
            
            % Forward pass
            [predictions, cache] = neural_network_forward(model, X_batch');
            
            % Compute loss (MSE)
            loss = mean((predictions - y_batch').^2);
            epoch_loss = epoch_loss + loss;
            num_batches = num_batches + 1;
            
            % Backward pass
            gradients = neural_network_backward_regression(model, X_batch', y_batch', predictions, cache);
            
            % Update weights
            model = update_weights(model, gradients, learning_rate);
        end
        
        % Average loss for the epoch
        history.loss(epoch) = epoch_loss / num_batches;
        
        % Compute full validation metrics periodically
        if mod(epoch, verbose) == 0 || epoch == 1
            [full_pred, ~] = neural_network_forward(model, X');
            mae = mean(abs(full_pred' - y));
            history.mae(epoch) = mae;
            fprintf('Epoch %d/%d: Loss = %.6f, MAE = %.6f\n', ...
                epoch, num_epochs, history.loss(epoch), mae);
        end
    end
end

function model = update_weights(model, gradients, learning_rate)
    % Update model weights using gradients
    for i = 1:length(model.layers)
        model.layers{i}.weights = model.layers{i}.weights - learning_rate * gradients{i}.weights;
        model.layers{i}.biases = model.layers{i}.biases - learning_rate * gradients{i}.biases;
    end
end