function [model, history] = train(X, y, model, options)
    % TRAIN - Train a neural network for Tic Tac Toe
    %
    % Syntax:
    %   [model, history] = train(X, y, model, options)
    %
    % Inputs:
    %   X       - Training data matrix (samples x features)
    %   y       - Target labels (samples x classes, one-hot encoded)
    %   model   - Neural network model structure
    %   options - Training options structure with fields:
    %             .num_epochs (number of training epochs)
    %             .learning_rate (learning rate for gradient descent)
    %             .batch_size (mini-batch size)
    %             .verbose (print progress every N epochs)
    %
    % Outputs:
    %   model   - Trained model
    %   history - Training history with loss and accuracy
    %
    % See also: NEURAL_NETWORK, PREDICT
    
    % Add paths
    if ~exist('neural_network_forward', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath'))));
    end
    
    % Validate inputs
    if nargin < 4
        error('train:NotEnoughInputs', ...
            'Requires 4 inputs: X, y, model, options');
    end
    
    % Extract options
    num_epochs = options.num_epochs;
    learning_rate = options.learning_rate;
    batch_size = options.batch_size;
    verbose = options.verbose;
    
    % Initialize history
    history.loss = zeros(num_epochs, 1);
    history.accuracy = zeros(num_epochs, 1);
    
    % Training loop
    for epoch = 1:num_epochs
        % Shuffle the data
        idx = randperm(size(X, 1));
        X_shuffled = X(idx, :);
        y_shuffled = y(idx, :);
        
        epoch_loss = 0;
        num_batches = 0;
        
        % Mini-batch training
        for i = 1:batch_size:size(X, 1)
            % Get mini-batch
            batch_end = min(i + batch_size - 1, size(X, 1));
            X_batch = X_shuffled(i:batch_end, :);
            y_batch = y_shuffled(i:batch_end, :);
            
            % Forward pass
            [predictions, cache] = neural_network_forward(model, X_batch');
            
            % Compute loss
            loss = compute_loss(predictions, y_batch');
            epoch_loss = epoch_loss + loss;
            num_batches = num_batches + 1;
            
            % Backward pass
            gradients = neural_network_backward(model, X_batch', y_batch', predictions, cache);
            
            % Update weights
            model = update_weights(model, gradients, learning_rate);
        end
        
        % Average loss for the epoch
        history.loss(epoch) = epoch_loss / num_batches;
        
        % Compute accuracy periodically
        if mod(epoch, verbose) == 0 || epoch == 1
            [full_pred, ~] = neural_network_forward(model, X');
            accuracy = compute_accuracy(full_pred, y');
            history.accuracy(epoch) = accuracy;
            fprintf('Epoch %d/%d: Loss = %.4f, Accuracy = %.2f%%\n', ...
                epoch, num_epochs, history.loss(epoch), accuracy * 100);
        end
    end
end

function loss = compute_loss(predictions, targets)
    % COMPUTE_LOSS - Compute cross-entropy loss
    % Add small epsilon for numerical stability
    epsilon = 1e-10;
    loss = -mean(sum(targets .* log(predictions + epsilon), 1));
end

function accuracy = compute_accuracy(predictions, targets)
    % COMPUTE_ACCURACY - Compute classification accuracy
    [~, predicted_classes] = max(predictions, [], 1);
    [~, true_classes] = max(targets, [], 1);
    accuracy = mean(predicted_classes == true_classes);
end

function model = update_weights(model, gradients, learning_rate)
    % UPDATE_WEIGHTS - Apply gradient descent update
    for i = 1:length(model.layers)
        model.layers{i}.weights = model.layers{i}.weights - learning_rate * gradients{i}.weights;
        model.layers{i}.biases = model.layers{i}.biases - learning_rate * gradients{i}.biases;
    end
end

