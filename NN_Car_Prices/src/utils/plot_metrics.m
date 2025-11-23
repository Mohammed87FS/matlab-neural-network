function plot_metrics(varargin)
    % PLOT_METRICS - Visualization utilities for neural network training and evaluation
    %
    % Syntax:
    %   plot_metrics('history', history, 'type', 'classification')
    %   plot_metrics('history', history, 'type', 'regression')
    %   plot_metrics('confusion', confusion_matrix)
    %   plot_metrics('confusion', confusion_matrix, 'labels', class_labels)
    %   plot_metrics('regression_results', y_true, y_pred)
    %   plot_metrics('learning_curve', train_history, val_history)
    %
    % Options:
    %   'history'   - Plot training history (loss and accuracy/metrics)
    %   'confusion' - Plot confusion matrix
    %   'regression_results' - Plot regression predictions vs actual
    %   'learning_curve' - Plot learning curves for train/validation
    %
    % Examples:
    %   % Plot classification training history
    %   plot_metrics('history', history, 'type', 'classification');
    %
    %   % Plot confusion matrix
    %   plot_metrics('confusion', metrics.confusion_matrix, 'labels', {'Class A', 'Class B', 'Class C'});
    %
    %   % Plot regression results
    %   plot_metrics('regression_results', y_test, predictions);
    %
    % See also: EVALUATE_MODEL, TRAIN
    
    % Parse inputs
    if nargin < 2
        error('plot_metrics:NotEnoughInputs', 'At least 2 arguments required');
    end
    
    plot_type = varargin{1};
    
    switch lower(plot_type)
        case 'history'
            history = varargin{2};
            opts = parse_options(varargin(3:end));
            plot_training_history(history, opts);
            
        case 'confusion'
            confusion_matrix = varargin{2};
            opts = parse_options(varargin(3:end));
            plot_confusion_matrix(confusion_matrix, opts);
            
        case 'regression_results'
            y_true = varargin{2};
            y_pred = varargin{3};
            opts = parse_options(varargin(4:end));
            plot_regression_results(y_true, y_pred, opts);
            
        case 'learning_curve'
            train_history = varargin{2};
            val_history = varargin{3};
            opts = parse_options(varargin(4:end));
            plot_learning_curve(train_history, val_history, opts);
            
        otherwise
            error('plot_metrics:UnknownType', 'Unknown plot type: %s', plot_type);
    end
end

function plot_training_history(history, opts)
    % PLOT_TRAINING_HISTORY - Plot training history
    
    if isfield(opts, 'type')
        task_type = opts.type;
    else
        task_type = 'classification';
    end
    
    figure('Position', [100, 100, 1200, 400]);
    
    if strcmpi(task_type, 'classification')
        % Classification: plot loss and accuracy
        subplot(1, 2, 1);
        plot(history.loss, 'LineWidth', 2);
        xlabel('Epoch', 'FontSize', 12);
        ylabel('Loss', 'FontSize', 12);
        title('Training Loss', 'FontSize', 14, 'FontWeight', 'bold');
        grid on;
        
        subplot(1, 2, 2);
        % Only plot non-zero accuracy values
        acc_idx = history.accuracy > 0;
        epochs = find(acc_idx);
        plot(epochs, history.accuracy(acc_idx) * 100, 'LineWidth', 2, 'Color', [0.2 0.6 0.8]);
        xlabel('Epoch', 'FontSize', 12);
        ylabel('Accuracy (%)', 'FontSize', 12);
        title('Training Accuracy', 'FontSize', 14, 'FontWeight', 'bold');
        grid on;
        
    else
        % Regression: plot loss and MAE
        subplot(1, 2, 1);
        plot(history.loss, 'LineWidth', 2, 'Color', [0.8 0.2 0.2]);
        xlabel('Epoch', 'FontSize', 12);
        ylabel('MSE Loss', 'FontSize', 12);
        title('Training Loss (MSE)', 'FontSize', 14, 'FontWeight', 'bold');
        grid on;
        
        if isfield(history, 'mae')
            subplot(1, 2, 2);
            mae_idx = history.mae > 0;
            epochs = find(mae_idx);
            plot(epochs, history.mae(mae_idx), 'LineWidth', 2, 'Color', [0.2 0.6 0.2]);
            xlabel('Epoch', 'FontSize', 12);
            ylabel('MAE', 'FontSize', 12);
            title('Mean Absolute Error', 'FontSize', 14, 'FontWeight', 'bold');
            grid on;
        end
    end
    
    sgtitle('Training History', 'FontSize', 16, 'FontWeight', 'bold');
end

function plot_confusion_matrix(conf_matrix, opts)
    % PLOT_CONFUSION_MATRIX - Plot confusion matrix as heatmap
    
    num_classes = size(conf_matrix, 1);
    
    % Get class labels if provided
    if isfield(opts, 'labels')
        class_labels = opts.labels;
    else
        class_labels = cellstr(num2str((1:num_classes)'));
    end
    
    figure('Position', [100, 100, 700, 600]);
    
    % Create heatmap
    imagesc(conf_matrix);
    colormap('hot');
    colorbar;
    
    % Add text annotations
    for i = 1:num_classes
        for j = 1:num_classes
            text(j, i, sprintf('%d', conf_matrix(i,j)), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'FontSize', 12, ...
                'FontWeight', 'bold', ...
                'Color', 'white');
        end
    end
    
    % Labels and title
    xlabel('Predicted Class', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('True Class', 'FontSize', 12, 'FontWeight', 'bold');
    title('Confusion Matrix', 'FontSize', 14, 'FontWeight', 'bold');
    
    % Set ticks
    set(gca, 'XTick', 1:num_classes, 'XTickLabel', class_labels);
    set(gca, 'YTick', 1:num_classes, 'YTickLabel', class_labels);
    set(gca, 'TickLength', [0 0]);
    
    % Rotate x-axis labels if needed
    if num_classes > 5
        xtickangle(45);
    end
    
    axis square;
end

function plot_regression_results(y_true, y_pred, opts)
    % PLOT_REGRESSION_RESULTS - Plot regression predictions vs actual values
    
    % Ensure column vectors
    if size(y_true, 2) > 1
        y_true = y_true(:);
    end
    if size(y_pred, 2) > 1
        y_pred = y_pred(:);
    end
    
    figure('Position', [100, 100, 1200, 400]);
    
    % Scatter plot: Predicted vs Actual
    subplot(1, 2, 1);
    scatter(y_true, y_pred, 50, 'filled', 'MarkerFaceAlpha', 0.6);
    hold on;
    
    % Perfect prediction line
    min_val = min([y_true; y_pred]);
    max_val = max([y_true; y_pred]);
    plot([min_val max_val], [min_val max_val], 'r--', 'LineWidth', 2);
    
    xlabel('Actual Values', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Predicted Values', 'FontSize', 12, 'FontWeight', 'bold');
    title('Predictions vs Actual', 'FontSize', 14, 'FontWeight', 'bold');
    legend('Predictions', 'Perfect Fit', 'Location', 'best');
    grid on;
    axis equal;
    
    % Residuals plot
    subplot(1, 2, 2);
    residuals = y_true - y_pred;
    scatter(y_pred, residuals, 50, 'filled', 'MarkerFaceAlpha', 0.6, 'MarkerFaceColor', [0.8 0.2 0.2]);
    hold on;
    yline(0, 'k--', 'LineWidth', 2);
    
    xlabel('Predicted Values', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Residuals', 'FontSize', 12, 'FontWeight', 'bold');
    title('Residual Plot', 'FontSize', 14, 'FontWeight', 'bold');
    grid on;
    
    sgtitle('Regression Results', 'FontSize', 16, 'FontWeight', 'bold');
    
    % Print metrics
    mse = mean(residuals.^2);
    mae = mean(abs(residuals));
    fprintf('\n=== Regression Metrics ===\n');
    fprintf('MSE: %.4f\n', mse);
    fprintf('RMSE: %.4f\n', sqrt(mse));
    fprintf('MAE: %.4f\n', mae);
end

function plot_learning_curve(train_history, val_history, opts)
    % PLOT_LEARNING_CURVE - Plot learning curves for training and validation
    
    figure('Position', [100, 100, 1200, 400]);
    
    % Plot loss
    subplot(1, 2, 1);
    plot(train_history.loss, 'LineWidth', 2, 'DisplayName', 'Training');
    hold on;
    plot(val_history.loss, 'LineWidth', 2, 'DisplayName', 'Validation');
    xlabel('Epoch', 'FontSize', 12);
    ylabel('Loss', 'FontSize', 12);
    title('Learning Curve - Loss', 'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'best');
    grid on;
    
    % Plot accuracy (if available)
    if isfield(train_history, 'accuracy') && isfield(val_history, 'accuracy')
        subplot(1, 2, 2);
        train_acc_idx = train_history.accuracy > 0;
        val_acc_idx = val_history.accuracy > 0;
        
        train_epochs = find(train_acc_idx);
        val_epochs = find(val_acc_idx);
        
        plot(train_epochs, train_history.accuracy(train_acc_idx) * 100, ...
            'LineWidth', 2, 'DisplayName', 'Training');
        hold on;
        plot(val_epochs, val_history.accuracy(val_acc_idx) * 100, ...
            'LineWidth', 2, 'DisplayName', 'Validation');
        
        xlabel('Epoch', 'FontSize', 12);
        ylabel('Accuracy (%)', 'FontSize', 12);
        title('Learning Curve - Accuracy', 'FontSize', 14, 'FontWeight', 'bold');
        legend('Location', 'best');
        grid on;
    end
    
    sgtitle('Learning Curves', 'FontSize', 16, 'FontWeight', 'bold');
end

function opts = parse_options(args)
    % PARSE_OPTIONS - Parse name-value pair arguments
    
    opts = struct();
    i = 1;
    while i <= length(args)
        if i == length(args)
            error('plot_metrics:InvalidArgs', 'Name-value pairs must come in pairs');
        end
        opts.(args{i}) = args{i+1};
        i = i + 2;
    end
end

