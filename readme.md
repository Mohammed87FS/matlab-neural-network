# MATLAB Neural Network Project

This project implements a simple neural network from scratch using MATLAB. It includes the main components necessary for defining, training, and using a neural network for predictions.

## Project Structure

```
matlab-neural-network
├── src
│   ├── neural_network.m        % Main implementation of the neural network
│   ├── train.m                 % Training function for the neural network
│   ├── predict.m               % Prediction function for new data
│   └── utils
│       └── activation_functions.m % Various activation functions
├── data
│   └── sample_dataset.mat       % Sample dataset for training/testing
├── models
│   └── saved_model.mat          % Trained model parameters
├── tests
│   └── test_neural_network.m    % Unit tests for the neural network
├── package.json                 % Configuration file for npm
└── README.md                    % Documentation for the project
```

## Setup Instructions

1. Clone the repository or download the project files.
2. Open MATLAB and navigate to the project directory.
3. Generate the sample dataset by running:
   ```matlab
   generate_data();
   ```
4. Run the `simple_nn.m` script to train the neural network on the sample dataset.

## Usage

- To train the neural network, run:
  ```matlab
  simple_nn();
  ```
- To make predictions using the trained model, use:
  ```matlab
  load('models/saved_model.mat');
  predictions = predict(model, new_data);
  ```

## Neural Network Functionality

- **Architecture**: The neural network architecture is defined in `neural_network.m`, where you can customize the number of layers and neurons.
- **Training**: The training process is handled in `train.m`, which includes forward propagation, loss calculation, and backpropagation for weight updates.
- **Activation Functions**: Various activation functions such as sigmoid, ReLU, and softmax are implemented in `src/utils/activation_functions.m`.

## Testing

Unit tests for the neural network functions are included in `tests/test_neural_network.m`. Run the tests to ensure that the implementation works as expected.

#
