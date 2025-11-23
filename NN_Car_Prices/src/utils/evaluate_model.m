function metrics = evaluate_model(model, X_test, y_test, task_type)
    % EVALUATE_MODEL - Evaluate neural network model performance
    %
    % Syntax:
    %   metrics = evaluate_model(model, X_test, y_test, 'classification')
    %   metrics = evaluate_model(model, X_test, y_test, 'regression')
    %
    % Inputs:
    %   model     - Trained neural network model
    %   X_test    - Test data (samples x features)
    %   y_test    - True labels/values
    %   task_type - Either 'classification' or 'regression'
    %
    % Outputs:
    %   metrics - Structure containing evaluation metrics
    %
    % Classification metrics:
    %   - accuracy: Overall accuracy
    %   - precision: Precision per class
    %   - recall: Recall per class
    %   - f1_score: F1 score per class
    %   - confusion_matrix: Confusion matrix
    %
    % Regression metrics:
    %   - mse: Mean Squared Error
    %   - rmse: Root Mean Squared Error
    %   - mae: Mean Absolute Error
    %   - r2: R-squared score
    %
    % Examples:
    %   % For classification
    %   metrics = evaluate_model(model, X_test, y_test, 'classification');
    %   fprintf('Accuracy: %.2f%%\n', metrics.accuracy * 100);
    %
    %   % For regression
    %   metrics = evaluate_model(model, X_test, y_test, 'regression');
    %   fprintf('RMSE: %.4f\n', metrics.rmse);
    %
    % See also: PREDICT, PREDICT_REGRESSION, PLOT_METRICS
    
    % Validate inputs
    if ~isstruct(model) || ~isfield(model, 'layers')
        error('evaluate_model:InvalidModel', 'Invalid model structure');
    end
    
    if nargin < 4
        error('evaluate_model:MissingTaskType', ...
            'Must specify task_type: ''classification'' or ''regression''');
    end
    
    % Make predictions
    switch lower(task_type)
        case 'classification'
            predictions = predict(model, X_test);
            metrics = evaluate_classification(predictions, y_test);
            
        case 'regression'
            predictions = predict_regression(model, X_test);
            metrics = evaluate_regression(predictions, y_test);
            
        otherwise
            error('evaluate_model:InvalidTaskType', ...
                'Task type must be ''classification'' or ''regression''');
    end
end

function metrics = evaluate_classification(predictions, y_test)
    % EVALUATE_CLASSIFICATION - Compute classification metrics
    
    % Convert to class labels
    [~, pred_classes] = max(predictions, [], 2);
    [~, true_classes] = max(y_test, [], 2);
    
    num_classes = size(y_test, 2);
    num_samples = length(true_classes);
    
    % Accuracy
    metrics.accuracy = mean(pred_classes == true_classes);
    
    % Confusion matrix
    metrics.confusion_matrix = zeros(num_classes, num_classes);
    for i = 1:num_samples
        metrics.confusion_matrix(true_classes(i), pred_classes(i)) = ...
            metrics.confusion_matrix(true_classes(i), pred_classes(i)) + 1;
    end
    
    % Per-class metrics
    metrics.precision = zeros(num_classes, 1);
    metrics.recall = zeros(num_classes, 1);
    metrics.f1_score = zeros(num_classes, 1);
    
    for c = 1:num_classes
        % True positives, false positives, false negatives
        tp = metrics.confusion_matrix(c, c);
        fp = sum(metrics.confusion_matrix(:, c)) - tp;
        fn = sum(metrics.confusion_matrix(c, :)) - tp;
        
        % Precision
        if (tp + fp) > 0
            metrics.precision(c) = tp / (tp + fp);
        else
            metrics.precision(c) = 0;
        end
        
        % Recall
        if (tp + fn) > 0
            metrics.recall(c) = tp / (tp + fn);
        else
            metrics.recall(c) = 0;
        end
        
        % F1 Score
        if (metrics.precision(c) + metrics.recall(c)) > 0
            metrics.f1_score(c) = 2 * (metrics.precision(c) * metrics.recall(c)) / ...
                (metrics.precision(c) + metrics.recall(c));
        else
            metrics.f1_score(c) = 0;
        end
    end
    
    % Average metrics
    metrics.avg_precision = mean(metrics.precision);
    metrics.avg_recall = mean(metrics.recall);
    metrics.avg_f1_score = mean(metrics.f1_score);
end

function metrics = evaluate_regression(predictions, y_test)
    % EVALUATE_REGRESSION - Compute regression metrics
    
    % Ensure correct dimensions
    if size(predictions, 1) ~= size(y_test, 1)
        if size(predictions, 2) == size(y_test, 1)
            predictions = predictions';
        end
    end
    
    if size(y_test, 2) > 1 && size(predictions, 2) == 1
        y_test = y_test(:, 1);
    end
    
    % Number of samples
    n = length(y_test);
    
    % Mean Squared Error
    metrics.mse = mean((predictions - y_test).^2);
    
    % Root Mean Squared Error
    metrics.rmse = sqrt(metrics.mse);
    
    % Mean Absolute Error
    metrics.mae = mean(abs(predictions - y_test));
    
    % R-squared
    ss_res = sum((y_test - predictions).^2);
    ss_tot = sum((y_test - mean(y_test)).^2);
    
    if ss_tot > 0
        metrics.r2 = 1 - (ss_res / ss_tot);
    else
        metrics.r2 = 0;
    end
    
    % Mean Absolute Percentage Error (if no zeros in y_test)
    if all(y_test ~= 0)
        metrics.mape = mean(abs((y_test - predictions) ./ y_test)) * 100;
    else
        metrics.mape = NaN;
    end
    
    % Additional metrics
    metrics.explained_variance = 1 - var(y_test - predictions) / var(y_test);
    metrics.max_error = max(abs(y_test - predictions));
end

