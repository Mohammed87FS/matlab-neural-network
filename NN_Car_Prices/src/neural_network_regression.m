function model = neural_network_regression(input_size, hidden_size, output_size, varargin)
    % NEURAL_NETWORK_REGRESSION - Initialize a neural network for regression
    %
    % Syntax:
    %   model = neural_network_regression(input_size, hidden_size, output_size)
    %   model = neural_network_regression(input_size, hidden_size, output_size, 'ParamName', ParamValue, ...)
    %
    % Inputs:
    %   input_size  - Number of input features
    %   hidden_size - Number of neurons in the hidden layer (can be array for multiple layers)
    %   output_size - Number of output values (typically 1 for regression)
    %
    % Optional Parameters (Name-Value pairs):
    %   'activation'     - Activation function for hidden layer (default: 'relu')
    %   'init_method'    - Weight initialization method: 'xavier', 'he', 'normal' (default: 'he')
    %
    % Outputs:
    %   model - Initialized neural network model structure
    %
    % Examples:
    %   % Create a simple regression network
    %   model = neural_network_regression(10, 64, 1);
    %
    %   % Create with custom activation
    %   model = neural_network_regression(10, 64, 1, 'activation', 'tanh');
    %
    % See also: NEURAL_NETWORK, TRAIN_REGRESSION, PREDICT_REGRESSION
    
    % Parse optional inputs
    p = inputParser;
    addOptional(p, 'activation', 'relu');
    addOptional(p, 'init_method', 'he');
    parse(p, varargin{:});
    
    activation = p.Results.activation;
    init_method = p.Results.init_method;
    
    % Validate inputs
    if input_size < 1 || any(hidden_size < 1) || output_size < 1
        error('neural_network_regression:InvalidSize', 'All sizes must be positive integers');
    end
    
    % Initialize layers
    model.layers = {};
    
    % Hidden layer
    layer1 = struct();
    layer1.weights = initialize_weights(hidden_size, input_size, init_method, activation);
    layer1.biases = zeros(hidden_size, 1);
    layer1.activation_function = @(x) activation_functions(activation, x);
    layer1.activation_derivative = @(x) activation_functions([activation '_derivative'], x);
    model.layers{1} = layer1;
    
    % Output layer (linear for regression)
    layer2 = struct();
    layer2.weights = initialize_weights(output_size, hidden_size, 'xavier', 'linear');
    layer2.biases = zeros(output_size, 1);
    layer2.activation_function = @(x) x;  % Linear activation
    layer2.activation_derivative = @(x) ones(size(x));  % Derivative of linear is 1
    model.layers{2} = layer2;
end

function W = initialize_weights(rows, cols, method, activation)
    % INITIALIZE_WEIGHTS - Initialize weights based on method
    switch lower(method)
        case 'xavier'
            % Xavier/Glorot initialization
            limit = sqrt(6 / (rows + cols));
            W = (rand(rows, cols) * 2 - 1) * limit;
            
        case 'he'
            % He initialization (good for ReLU)
            if contains(lower(activation), 'relu')
                W = randn(rows, cols) * sqrt(2 / cols);
            else
                W = randn(rows, cols) * sqrt(1 / cols);
            end
            
        case 'normal'
            % Simple normal initialization
            W = randn(rows, cols) * 0.01;
            
        otherwise
            W = randn(rows, cols) * 0.01;
    end
end