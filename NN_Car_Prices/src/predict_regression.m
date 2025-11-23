function predictions = predict_regression(model, input_data)
    % PREDICT_REGRESSION - Make predictions using a trained neural network (regression)
    %
    % Syntax:
    %   predictions = predict_regression(model, input_data)
    %
    % Inputs:
    %   model      - Trained neural network regression model structure
    %   input_data - Input data matrix (samples x features)
    %
    % Outputs:
    %   predictions - Predicted continuous values (samples x output_size)
    %
    % Examples:
    %   % Load trained model and make predictions
    %   load('models/car_price_model.mat', 'model');
    %   predictions = predict_regression(model, test_data);
    %
    % See also: PREDICT, NEURAL_NETWORK_REGRESSION, TRAIN_REGRESSION
    
    % Validate inputs
    if ~isstruct(model) || ~isfield(model, 'layers')
        error('predict_regression:InvalidModel', ...
            'Model must be a valid trained neural network structure');
    end
    
    if ~isnumeric(input_data) || isempty(input_data)
        error('predict_regression:InvalidInput', ...
            'Input data must be a non-empty numeric matrix');
    end
    
    % Check feature dimension matches model input
    expected_features = size(model.layers{1}.weights, 2);
    if size(input_data, 2) ~= expected_features
        error('predict_regression:DimensionMismatch', ...
            'Input data has %d features, but model expects %d features', ...
            size(input_data, 2), expected_features);
    end
    
    % Forward pass through the network
    layer_outputs = input_data';  % features x samples
    
    for i = 1:length(model.layers)
        layer = model.layers{i};
        layer_outputs = layer.activation_function(layer.weights * layer_outputs + layer.biases);
    end
    
    % Return predictions, transposed to samples x output_size
    predictions = layer_outputs';
end