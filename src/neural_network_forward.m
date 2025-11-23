function [predictions, cache] = neural_network_forward(model, X)
    % NEURAL_NETWORK_FORWARD - Forward propagation through the neural network
    %
    % Syntax:
    %   [predictions, cache] = neural_network_forward(model, X)
    %
    % Inputs:
    %   model - Neural network model structure with layers
    %   X     - Input data matrix (features x samples)
    %
    % Outputs:
    %   predictions - Network output (output_size x samples)
    %   cache       - Cell array storing intermediate values for backpropagation
    %                 Each cell contains:
    %                   .Z - Pre-activation values
    %                   .A - Post-activation values
    %
    % See also: NEURAL_NETWORK_BACKWARD, TRAIN
    
    % Validate inputs
    if ~isstruct(model) || ~isfield(model, 'layers')
        error('neural_network_forward:InvalidModel', 'Model must be a valid structure with layers field');
    end
    
    if ~isnumeric(X) || isempty(X)
        error('neural_network_forward:InvalidInput', 'Input X must be a non-empty numeric matrix');
    end
    
    % Forward pass through all layers
    output = X;
    cache = cell(length(model.layers), 1);
    
    for i = 1:length(model.layers)
        layer = model.layers{i};
        
        % Linear transformation: Z = W * A_prev + b
        z = layer.weights * output + layer.biases;
        cache{i}.Z = z;
        
        % Apply activation function: A = g(Z)
        output = layer.activation_function(z);
        cache{i}.A = output;
    end
    
    predictions = output;
end