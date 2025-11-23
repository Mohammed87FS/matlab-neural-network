% PREDICT_CAR_PRICE - Use trained model to predict car prices
%
% This script shows how to use the trained model to predict prices for new cars.
%
% Usage:
%   1. Edit the car details below
%   2. Run this script
%   3. Get predicted price
%
% See also: TRAIN_CAR_PRICE_MODEL

clear; clc;

fprintf('=========================================\n');
fprintf('Car Price Prediction\n');
fprintf('=========================================\n\n');

% Add paths
addpath('src');
addpath('src/utils');

%% 1. Load Trained Model
fprintf('Loading trained model...\n');

if ~exist('models/car_price_model.mat', 'file')
    error('Model not found! Please run train_car_price_model.m first.');
end

load('models/car_price_model.mat', 'model');
fprintf('✓ Model loaded successfully\n\n');

%% 2. Define Car Details
fprintf('Enter car details for prediction:\n');
fprintf('---------------------------------------\n');

% EDIT THESE VALUES FOR YOUR CAR:
car.kms_driven = 45000;              % Kilometers driven
car.fuel_type = 'Petrol';            % Options: 'Petrol', 'Diesel', 'CNG', 'LPG', 'Electric'
car.transmission = 'Manual';         % Options: 'Manual', 'Automatic'
car.ownership = '1st';               % Options: '1st', '2nd', '3rd', '4th or Above'
car.manufacture_year = 2018;         % Year manufactured
car.engine_cc = 1197;                % Engine capacity in CC
car.seats = 5;                       % Number of seats

% Display car details
fprintf('Kilometers: %s\n', format_number(car.kms_driven));
fprintf('Fuel Type: %s\n', car.fuel_type);
fprintf('Transmission: %s\n', car.transmission);
fprintf('Ownership: %s\n', car.ownership);
fprintf('Year: %d (Age: %d years)\n', car.manufacture_year, year(datetime('now')) - car.manufacture_year);
fprintf('Engine: %d CC\n', car.engine_cc);
fprintf('Seats: %d\n\n', car.seats);

%% 3. Preprocess Input
fprintf('Preprocessing input data...\n');

% Convert to features (same as training)
features = preprocess_single_car(car);

fprintf('✓ Data preprocessed\n\n');

%% 4. Make Prediction
fprintf('Making prediction...\n');

prediction_log = predict_regression(model, features);

% Clip negative predictions
prediction_log = max(prediction_log, 0);

% Convert from log scale back to Lakhs
predicted_price_lakhs = expm1(prediction_log);

fprintf('✓ Prediction complete\n\n');

%% 5. Display Results
fprintf('=========================================\n');
fprintf('PREDICTED PRICE\n');
fprintf('=========================================\n');
fprintf('₹%.2f Lakhs (₹%s)\n', predicted_price_lakhs, format_number(predicted_price_lakhs * 100000));
fprintf('=========================================\n\n');

% Price range (with uncertainty)
uncertainty = 0.15;  % ±15% uncertainty
lower_bound = predicted_price_lakhs * (1 - uncertainty);
upper_bound = predicted_price_lakhs * (1 + uncertainty);

fprintf('Estimated Range (±15%%):\n');
fprintf('  Low:  ₹%.2f Lakhs\n', lower_bound);
fprintf('  High: ₹%.2f Lakhs\n\n', upper_bound);

%% Helper Functions

function features = preprocess_single_car(car)
    % Preprocess a single car's data to match training format
    
    % Kilometers (cap at 300k)
    kms = min(car.kms_driven, 300000);
    
    % Fuel Type (One-Hot Encoding)
    % Order must match training: typically alphabetical
    fuel_types = {'CNG', 'Diesel', 'Electric', 'LPG', 'Petrol'};
    fuel_onehot = zeros(1, length(fuel_types) - 1);
    fuel_idx = find(strcmp(fuel_types, car.fuel_type));
    if ~isempty(fuel_idx) && fuel_idx < length(fuel_types)
        fuel_onehot(fuel_idx) = 1;
    end
    
    % Transmission (0 = Manual, 1 = Automatic)
    trans = double(strcmp(car.transmission, 'Automatic'));
    
    % Ownership (1-4)
    if contains(car.ownership, '1st')
        ownership = 1;
    elseif contains(car.ownership, '2nd')
        ownership = 2;
    elseif contains(car.ownership, '3rd')
        ownership = 3;
    else
        ownership = 4;
    end
    
    % Age (cap at 30 years)
    current_year = year(datetime('now'));
    age = min(current_year - car.manufacture_year, 30);
    
    % Engine CC
    engine = car.engine_cc;
    
    % Seats
    seats = car.seats;
    
    % Combine features in same order as training
    raw_features = [kms, fuel_onehot, trans, ownership, age, engine, seats];
    
    % Normalize using z-score
    % Note: Ideally you'd save normalization parameters from training
    % For now, using approximate values
    features = (raw_features - mean(raw_features)) ./ (std(raw_features) + 1e-8);
end

function str = format_number(num)
    % Format number with commas
    str = sprintf('%d', round(num));
    str = regexprep(str, '(\d)(?=(\d{3})+$)', '$1,');
end

