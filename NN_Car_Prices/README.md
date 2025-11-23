# MATLAB Neural Network - Car Price Prediction

A production-ready neural network implementation in MATLAB for predicting car prices using real-world data. Built from scratch without deep learning toolboxes.

[![MATLAB](https://img.shields.io/badge/MATLAB-R2019b+-orange.svg)](https://www.mathworks.com/products/matlab.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Overview

This project implements a neural network from scratch to predict car prices based on:
- **Kilometers driven**
- **Fuel type** (Petrol, Diesel, CNG, etc.)
- **Transmission** (Manual/Automatic)
- **Ownership history** (1st, 2nd, 3rd owner)
- **Car age**
- **Engine capacity** (CC)
- **Number of seats**

## Quick Start

```matlab
% Train the model
train_car_price_model

% That's it! The script will:
% 1. Load the car price dataset
% 2. Preprocess and normalize features
% 3. Train the neural network
% 4. Evaluate performance
% 5. Generate visualizations
% 6. Save the trained model
```

##  Requirements

- MATLAB R2019b or later
- No additional toolboxes required!

##  Installation

```bash
git clone https://github.com/yourusername/matlab-neural-network.git
cd matlab-neural-network
```

##  Dataset

**File:** `data/car_price.csv`

Real-world car pricing data with features:
- Car prices (in Rupees - Lakhs/Crores)
- Kilometers driven
- Fuel type (categorical)
- Transmission type
- Ownership history
- Manufacturing year
- Engine capacity
- Seating capacity

##  Project Structure

```
matlab-neural-network/
├── src/
│   ├── neural_network.m                 # Classification network
│   ├── neural_network_regression.m      # Regression network
│   ├── neural_network_forward.m         # Forward propagation
│   ├── neural_network_backward.m        # Backpropagation (classification)
│   ├── neural_network_backward_regression.m  # Backpropagation (regression)
│   ├── train.m                          # Training (classification)
│   ├── train_regression.m               # Training (regression)
│   ├── predict.m                        # Prediction (classification)
│   ├── predict_regression.m             # Prediction (regression)
│   └── utils/
│       ├── activation_functions.m       # Activation functions library
│       ├── data_preprocessing.m         # Data preprocessing utilities
│       ├── evaluate_model.m             # Model evaluation metrics
│       └── plot_metrics.m               # Visualization utilities
├── data/
│   └── car_price.csv                    # Car price dataset
├── models/
│   └── car_price_model.mat              # Saved trained model
├── train_car_price_model.m              # Main training script
└── README.md
```

##  How It Works

### 1. Data Preprocessing
- Extracts numeric features from text fields
- One-hot encodes categorical variables (fuel type)
- Normalizes all features using z-score standardization
- Scales target prices for better training

### 2. Neural Network Architecture
```
Input Layer (n features) 
    ↓
Hidden Layer (64 neurons, ReLU activation)
    ↓
Output Layer (1 neuron, Linear activation)
```

### 3. Training
- **Loss Function:** Mean Squared Error (MSE)
- **Optimizer:** Mini-batch Gradient Descent
- **Batch Size:** 32
- **Learning Rate:** 0.001
- **Epochs:** 100

### 4. Evaluation Metrics
- **MAE** (Mean Absolute Error) - Average prediction error
- **RMSE** (Root Mean Squared Error) - Penalizes large errors
- **MAPE** (Mean Absolute Percentage Error) - Error as percentage

## API Reference

### Training

```matlab
% Initialize regression network
model = neural_network_regression(input_size, hidden_size, output_size);

% Set training options
options.num_epochs = 100;
options.learning_rate = 0.001;
options.batch_size = 32;
options.verbose = 10;  % Print every 10 epochs

% Train
[model, history] = train_regression(X_train, y_train, model, options);
```

### Prediction

```matlab
% Load trained model
load('models/car_price_model.mat', 'model');

% Prepare new data (must be preprocessed the same way)
new_data = [...];  % Your preprocessed features

% Predict
predictions = predict_regression(model, new_data);
```

### Data Preprocessing

```matlab
% Normalize data
[X_norm, params] = data_preprocessing('normalize', X, 'method', 'zscore');

% Split train/test
[X_train, X_test, y_train, y_test] = data_preprocessing('split', X, y, 'ratio', 0.8);
```

### Visualization

```matlab
% Plot training history
plot_metrics('history', history, 'type', 'regression');

% Plot predictions vs actual
plot_metrics('regression_results', y_actual, y_predicted);
```

## Expected Performance

Typical results on the car price dataset:
- **MAE:** ~2-3 Lakhs
- **RMSE:** ~3-5 Lakhs
- **MAPE:** ~10-15%

Performance depends on:
- Dataset quality and size
- Feature engineering
- Hyperparameter tuning
- Training duration

## 🔧 Customization

### Adjust Network Architecture

```matlab
% Larger hidden layer for more complex patterns
model = neural_network_regression(input_size, 128, output_size);

% Different activation function
model = neural_network_regression(input_size, 64, output_size, 'activation', 'tanh');
```

### Modify Training Parameters

```matlab
options.num_epochs = 200;      % Train longer
options.learning_rate = 0.01;  % Faster learning
options.batch_size = 64;       % Larger batches
```

### Use Different Features

Edit the `preprocess_car_data` function in `train_car_price_model.m` to:
- Add new features
- Remove features
- Change encoding methods

##  Core Features

### Activation Functions
- ReLU, Leaky ReLU
- Sigmoid, Tanh
- Softmax (for classification)
- Linear (for regression)

### Weight Initialization
- He initialization (for ReLU)
- Xavier/Glorot initialization
- Normal initialization

### Data Preprocessing
- Z-score normalization
- Min-max normalization
- Max-abs normalization
- Train/test splitting
- One-hot encoding

### Model Evaluation
- Regression: MSE, RMSE, MAE, R², MAPE
- Classification: Accuracy, Precision, Recall, F1-Score, Confusion Matrix

##  Use Cases

This implementation can be adapted for:
1. **Regression Tasks**
   - Price prediction
   - Sales forecasting
   - Demand estimation

2. **Classification Tasks**
   - Binary classification
   - Multi-class classification
   - Pattern recognition

##  Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request
