function gradients = neural_network_backward(model, X, y, predictions, cache)
    % NEURAL_NETWORK_BACKWARD - Backward propagation for classification
    %
    % Syntax:
    %   gradients = neural_network_backward(model, X, y, predictions, cache)
    %
    % Inputs:
    %   model       - Neural network model structure
    %   X           - Input data (features x samples)
    %   y           - True target labels (output_size x samples, one-hot encoded)
    %   predictions - Network predictions from forward pass
    %   cache       - Cached values from forward pass
    %
    % Outputs:
    %   gradients - Cell array of gradient structures
    %
    % Notes:
    %   Uses cross-entropy loss with softmax
    %   For softmax + cross-entropy: dL/dZ = predictions - targets
    %
    % See also: NEURAL_NETWORK_FORWARD, TRAIN_TICTACTOE
    
    % Validate inputs
    if ~isstruct(model) || ~isfield(model, 'layers')
        error('neural_network_backward:InvalidModel', 'Model must be a valid structure');
    end
    
    % Number of samples
    m = size(X, 2);
    
    % Initialize gradients
    gradients = cell(length(model.layers), 1);
    
    % Output layer gradient
    % For softmax + cross-entropy: dL/dZ = predictions - targets
    dZ = predictions - y;
    
    % Get previous layer activation
    layer = model.layers{end};
    if length(model.layers) > 1
        prev_A = cache{end-1}.A;
    else
        prev_A = X;
    end
    
    % Compute gradients for output layer
    gradients{end}.weights = (1/m) * dZ * prev_A';
    gradients{end}.biases = (1/m) * sum(dZ, 2);
    
    % Hidden layers (backward)
    for i = length(model.layers)-1:-1:1
        layer = model.layers{i};
        
        % Backpropagate through activation
        dA = model.layers{i+1}.weights' * dZ;
        z = cache{i}.Z;
        dZ = dA .* layer.activation_derivative(z);
        
        % Get previous layer activation
        if i > 1
            prev_A = cache{i-1}.A;
        else
            prev_A = X;
        end
        
        % Compute gradients
        gradients{i}.weights = (1/m) * dZ * prev_A';
        gradients{i}.biases = (1/m) * sum(dZ, 2);
    end
end

