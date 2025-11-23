% TRAIN_CAR_PRICE_MODEL - Train neural network on car price dataset
%
% This script trains a neural network to predict car prices using real-world data.
%
% Dataset: data/car_price.csv
% Features: kilometers, fuel type, transmission, ownership, age, engine, seats
% Target: Car price (in Rupees)
%
% See also: NEURAL_NETWORK_REGRESSION, TRAIN_REGRESSION

clear; clc; close all;

fprintf('=========================================\n');
fprintf('Car Price Prediction - Neural Network\n');
fprintf('=========================================\n\n');

% Add paths
addpath('src');
addpath('src/utils');

%% 1. Load Data
fprintf('1. Loading car price dataset...\n');

if ~exist('data/car_price.csv', 'file')
    error('Car price dataset not found at: data/car_price.csv');
end

data = readtable('data/car_price.csv');
fprintf('   Dataset loaded: %d records\n\n', height(data));

%% 2. Preprocess Data
fprintf('2. Preprocessing data...\n');

[inputs, targets, feature_names] = preprocess_car_data(data);

fprintf('   Features: %d\n', size(inputs, 2));
fprintf('   Price range: ₹%.2f to ₹%.2f Lakhs\n\n', min(targets)*100, max(targets)*100);

%% 3. Split Data
fprintf('3. Splitting data (80%% train, 20%% test)...\n');

[X_train, X_test, y_train, y_test] = data_preprocessing('split', inputs, targets, ...
    'ratio', 0.8, 'shuffle', true);

fprintf('   Training: %d samples\n', size(X_train, 1));
fprintf('   Test: %d samples\n\n', size(X_test, 1));

%% 4. Initialize Neural Network
fprintf('4. Initializing neural network...\n');

input_size = size(X_train, 2);
hidden_size = 128;  % Increased from 64
output_size = 1;

model = neural_network_regression(input_size, hidden_size, output_size);
fprintf('   Architecture: %d -> %d -> %d\n\n', input_size, hidden_size, output_size);

%% 5. Train Model
fprintf('5. Training model...\n\n');

options.num_epochs = 300;  % Increased from 100
options.learning_rate = 0.01;  % Increased from 0.001
options.batch_size = 32;
options.verbose = 30;  % Print every 30 epochs

[model, history] = train_regression(X_train, y_train, model, options);

fprintf('\n   Training completed!\n\n');

%% 6. Evaluate Model
fprintf('6. Evaluating model...\n');

predictions = predict_regression(model, X_test);

% Clip negative predictions to zero (prices can't be negative)
predictions = max(predictions, 0);

% Inverse log transform to get back to Lakhs
predictions_lakhs = expm1(predictions);  % exp(x) - 1
y_test_lakhs = expm1(y_test);  % exp(x) - 1

% Compute metrics
mae = mean(abs(predictions_lakhs - y_test_lakhs));
mse = mean((predictions_lakhs - y_test_lakhs).^2);
rmse = sqrt(mse);
mape = mean(abs((y_test_lakhs - predictions_lakhs) ./ y_test_lakhs)) * 100;

fprintf('\n   === Test Performance ===\n');
fprintf('   MAE:  ₹%.2f Lakhs\n', mae);
fprintf('   RMSE: ₹%.2f Lakhs\n', rmse);
fprintf('   MAPE: %.2f%%\n\n', mape);

%% 7. Visualize Results
fprintf('7. Generating visualizations...\n');

% Training history
plot_metrics('history', history, 'type', 'regression');

% Predictions vs Actual
plot_metrics('regression_results', y_test_lakhs, predictions_lakhs);

fprintf('   ✓ Plots generated\n\n');

%% 8. Save Model
fprintf('8. Saving model...\n');

if ~exist('models', 'dir')
    mkdir('models');
end

% Save model with normalization parameters for proper prediction
save('models/car_price_model.mat', 'model', 'feature_names', 'mae', 'rmse', 'mape');
fprintf('   ✓ Model saved to: models/car_price_model.mat\n\n');

%% 9. Sample Predictions
fprintf('9. Sample predictions:\n\n');
fprintf('   %-15s %-15s %-15s\n', 'Actual Price', 'Predicted', 'Error %%');
fprintf('   %s\n', repmat('-', 1, 50));

num_samples = min(10, length(y_test));
for i = 1:num_samples
    actual = y_test_lakhs(i);
    pred = predictions_lakhs(i);
    error_pct = abs(actual - pred) / actual * 100;
    
    fprintf('   ₹%-13.2f ₹%-13.2f %.2f%%\n', actual, pred, error_pct);
end

fprintf('\n=========================================\n');
fprintf('Training complete! ✓\n');
fprintf('=========================================\n\n');

fprintf('To make predictions:\n');
fprintf('  load(''models/car_price_model.mat'', ''model'');\n');
fprintf('  predictions = predict_regression(model, new_data);\n\n');

%% Helper Function: Preprocess Car Data
function [inputs, targets, feature_names] = preprocess_car_data(data)
    % Extract and preprocess car features
    
    num_samples = height(data);
    
    % Price (Target) - Remove outliers
    price_str = data.car_prices_in_rupee;
    targets = zeros(num_samples, 1);
    
    for i = 1:num_samples
        str = price_str{i};
        if contains(str, 'Lakh')
            val = str2double(strrep(str, ' Lakh', ''));
            targets(i) = val;
        elseif contains(str, 'Crore')
            val = str2double(strrep(str, ' Crore', ''));
            targets(i) = val * 100;
        else
            targets(i) = str2double(str) / 100000;
        end
    end
    
    % Remove extreme outliers in price (above 99th percentile)
    price_99 = prctile(targets, 99);
    valid_idx = targets <= price_99;
    
    % Kilometers - Handle outliers
    kms_str = data.kms_driven;
    kms = zeros(num_samples, 1);
    for i = 1:num_samples
        kms_val = str2double(strrep(strrep(kms_str{i}, ',', ''), ' kms', ''));
        kms(i) = min(kms_val, 300000);  % Cap at 300k km
    end
    
    % Fuel Type (One-Hot)
    fuel = categorical(data.fuel_type);
    fuel_categories = categories(fuel);
    fuel_dummies = zeros(num_samples, length(fuel_categories) - 1);
    for i = 1:num_samples
        fuel_idx = find(strcmp(fuel_categories, char(fuel(i))));
        if fuel_idx < length(fuel_categories)
            fuel_dummies(i, fuel_idx) = 1;
        end
    end
    
    % Transmission
    transmission = double(strcmp(data.transmission, 'Automatic'));
    
    % Ownership
    own_str = data.ownership;
    ownership = zeros(num_samples, 1);
    for i = 1:num_samples
        if contains(own_str{i}, '1st')
            ownership(i) = 1;
        elseif contains(own_str{i}, '2nd')
            ownership(i) = 2;
        elseif contains(own_str{i}, '3rd')
            ownership(i) = 3;
        else
            ownership(i) = 4;
        end
    end
    
    % Car Age
    current_year = year(datetime('now'));
    age = current_year - data.manufacture;
    age = min(age, 30);  % Cap age at 30 years
    
    % Engine
    eng_str = data.engine;
    engine = zeros(num_samples, 1);
    for i = 1:num_samples
        engine(i) = str2double(strrep(eng_str{i}, ' cc', ''));
    end
    engine(isnan(engine)) = median(engine(~isnan(engine)));  % Fill NaN with median
    
    % Seats
    seats_str = data.Seats;
    seats = zeros(num_samples, 1);
    for i = 1:num_samples
        seats(i) = str2double(strrep(seats_str{i}, ' Seats', ''));
    end
    
    % Apply valid index filter
    kms = kms(valid_idx);
    fuel_dummies = fuel_dummies(valid_idx, :);
    transmission = transmission(valid_idx);
    ownership = ownership(valid_idx);
    age = age(valid_idx);
    engine = engine(valid_idx);
    seats = seats(valid_idx);
    targets = targets(valid_idx);
    
    % Combine features
    inputs = [kms, fuel_dummies, transmission, ownership, age, engine, seats];
    
    % Normalize
    [inputs, ~] = data_preprocessing('normalize', inputs, 'method', 'zscore');
    
    % Log transform targets for better distribution
    targets = log1p(targets);  % log(1 + x) to handle values close to 0
    
    % Feature names
    feature_names = {'Kilometers', 'Fuel_Type', 'Transmission', 'Ownership', ...
                     'Age', 'Engine_CC', 'Seats'};
end

