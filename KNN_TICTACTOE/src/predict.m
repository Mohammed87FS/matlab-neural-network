function predictions = predict(model, input_data)
    % PREDICT - Make predictions using a trained neural network for Tic Tac Toe
    %
    % Syntax:
    %   predictions = predict(model, input_data)
    %
    % Inputs:
    %   model      - Trained neural network model structure
    %   input_data - Input data matrix (samples x features)
    %
    % Outputs:
    %   predictions - Predicted move probabilities (samples x 9)
    %                 Each row sums to 1 (softmax output)
    %
    % See also: PREDICT_TICTACTOE, NEURAL_NETWORK, TRAIN
    
    % Add paths
    if ~exist('neural_network_forward', 'file')
        addpath(fullfile(fileparts(mfilename('fullpath'))));
    end
    
    % Validate inputs
    if ~isstruct(model) || ~isfield(model, 'layers')
        error('predict:InvalidModel', 'Model must be a valid trained neural network structure');
    end
    
    if ~isnumeric(input_data) || isempty(input_data)
        error('predict:InvalidInput', 'Input data must be a non-empty numeric matrix');
    end
    
    % Check feature dimension matches model input
    expected_features = size(model.layers{1}.weights, 2);
    if size(input_data, 2) ~= expected_features
        error('predict:DimensionMismatch', ...
            'Input data has %d features, but model expects %d features', ...
            size(input_data, 2), expected_features);
    end
    
    % Forward pass through the network
    layer_outputs = input_data';  % Transpose to features x samples
    
    for i = 1:length(model.layers)
        layer = model.layers{i};
        layer_outputs = layer.activation_function(layer.weights * layer_outputs + layer.biases);
    end
    
    % Return the final output as predictions, transposed back to samples x classes
    predictions = layer_outputs';
end

