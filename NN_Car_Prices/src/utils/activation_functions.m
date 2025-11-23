function output = activation_functions(type, x, varargin)
    % ACTIVATION_FUNCTIONS - Collection of activation functions for neural networks
    %
    % Syntax:
    %   output = activation_functions(type, x)
    %   output = activation_functions(type, x, dim)
    %
    % Inputs:
    %   type - String specifying the activation function:
    %          'sigmoid', 'sigmoid_derivative'
    %          'relu', 'relu_derivative'
    %          'leaky_relu', 'leaky_relu_derivative'
    %          'tanh', 'tanh_derivative'
    %          'softmax', 'softmax_derivative'
    %          'linear', 'linear_derivative'
    %   x    - Input matrix or vector
    %   dim  - (Optional) Dimension for softmax normalization (default: 1)
    %
    % Outputs:
    %   output - Activated output
    %
    % Examples:
    %   y = activation_functions('relu', [-1, 0, 1])
    %   dy = activation_functions('relu_derivative', [-1, 0, 1])
    %
    % See also: NEURAL_NETWORK, NEURAL_NETWORK_FORWARD
    
    % Parse optional arguments
    if nargin > 2
        dim = varargin{1};
    else
        dim = 1;
    end
    
    % Input validation
    if ~ischar(type) && ~isstring(type)
        error('activation_functions:InvalidType', 'Type must be a string or char array');
    end
    
    if ~isnumeric(x)
        error('activation_functions:InvalidInput', 'Input x must be numeric');
    end
    
    % Apply the appropriate activation function
    switch lower(type)
        case 'sigmoid'
            output = 1 ./ (1 + exp(-x));
            
        case 'sigmoid_derivative'
            sig = 1 ./ (1 + exp(-x));
            output = sig .* (1 - sig);
            
        case 'relu'
            output = max(0, x);
            
        case 'relu_derivative'
            output = double(x > 0);
            
        case 'leaky_relu'
            alpha = 0.01;
            output = max(alpha * x, x);
            
        case 'leaky_relu_derivative'
            alpha = 0.01;
            output = double(x > 0) + alpha * double(x <= 0);
            
        case 'tanh'
            output = tanh(x);
            
        case 'tanh_derivative'
            output = 1 - tanh(x).^2;
            
        case 'softmax'
            % Numerical stability: subtract max
            exp_x = exp(x - max(x, [], dim));
            output = exp_x ./ sum(exp_x, dim);
            
        case 'softmax_derivative'
            % For softmax with cross-entropy, derivative is handled in backprop
            % This returns identity for simplicity
            output = ones(size(x));
            
        case 'linear'
            output = x;
            
        case 'linear_derivative'
            output = ones(size(x));
            
        otherwise
            error('activation_functions:UnknownType', ...
                'Unknown activation function type: %s', type);
    end
end