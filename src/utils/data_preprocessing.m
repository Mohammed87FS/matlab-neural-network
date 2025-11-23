function varargout = data_preprocessing(operation, data, varargin)
    % DATA_PREPROCESSING - Data preprocessing utilities for neural networks
    %
    % Syntax:
    %   [normalized_data, params] = data_preprocessing('normalize', data)
    %   [normalized_data, params] = data_preprocessing('normalize', data, 'method', 'minmax')
    %   denormalized_data = data_preprocessing('denormalize', normalized_data, params)
    %   [X_train, X_test, y_train, y_test] = data_preprocessing('split', X, y, 'ratio', 0.8)
    %   one_hot = data_preprocessing('one_hot_encode', labels, num_classes)
    %   labels = data_preprocessing('one_hot_decode', one_hot)
    %
    % Operations:
    %   'normalize'        - Normalize data (returns [data, params])
    %   'denormalize'      - Reverse normalization (requires params from normalize)
    %   'split'            - Split data into train/test sets
    %   'one_hot_encode'   - Convert labels to one-hot encoding
    %   'one_hot_decode'   - Convert one-hot back to labels
    %   'shuffle'          - Shuffle data randomly
    %
    % Examples:
    %   % Normalize data
    %   [X_norm, norm_params] = data_preprocessing('normalize', X, 'method', 'zscore');
    %
    %   % Split data
    %   [X_train, X_test, y_train, y_test] = data_preprocessing('split', X, y, 'ratio', 0.8);
    %
    %   % One-hot encode labels
    %   y_one_hot = data_preprocessing('one_hot_encode', labels, 3);
    %
    % See also: TRAIN, TRAIN_REGRESSION
    
    switch lower(operation)
        case 'normalize'
            [varargout{1}, varargout{2}] = normalize_data(data, varargin{:});
            
        case 'denormalize'
            if nargin < 3
                error('data_preprocessing:MissingParams', ...
                    'Denormalization requires params from normalization');
            end
            varargout{1} = denormalize_data(data, varargin{1});
            
        case 'split'
            if nargin < 3
                error('data_preprocessing:MissingLabels', ...
                    'Split operation requires both X and y');
            end
            y = varargin{1};
            opts = parse_options(varargin(2:end));
            [varargout{1}, varargout{2}, varargout{3}, varargout{4}] = split_data(data, y, opts);
            
        case 'one_hot_encode'
            if nargin < 3
                error('data_preprocessing:MissingNumClasses', ...
                    'One-hot encoding requires number of classes');
            end
            num_classes = varargin{1};
            varargout{1} = one_hot_encode(data, num_classes);
            
        case 'one_hot_decode'
            varargout{1} = one_hot_decode(data);
            
        case 'shuffle'
            varargout{1} = shuffle_data(data, varargin{:});
            
        otherwise
            error('data_preprocessing:UnknownOperation', ...
                'Unknown operation: %s', operation);
    end
end

function [normalized_data, params] = normalize_data(data, varargin)
    % NORMALIZE_DATA - Normalize data using specified method
    %
    % Default method: 'zscore' (standardization)
    % Options: 'zscore', 'minmax', 'maxabs'
    
    opts = parse_options(varargin);
    if isfield(opts, 'method')
        method = opts.method;
    else
        method = 'zscore';
    end
    
    params.method = method;
    
    switch lower(method)
        case 'zscore'
            % Z-score normalization: (x - mean) / std
            params.mean = mean(data, 1);
            params.std = std(data, 0, 1);
            params.std(params.std == 0) = 1;  % Avoid division by zero
            normalized_data = (data - params.mean) ./ params.std;
            
        case 'minmax'
            % Min-Max normalization: (x - min) / (max - min)
            params.min = min(data, [], 1);
            params.max = max(data, [], 1);
            range = params.max - params.min;
            range(range == 0) = 1;  % Avoid division by zero
            normalized_data = (data - params.min) ./ range;
            
        case 'maxabs'
            % Max Absolute normalization: x / max(abs(x))
            params.max_abs = max(abs(data), [], 1);
            params.max_abs(params.max_abs == 0) = 1;
            normalized_data = data ./ params.max_abs;
            
        otherwise
            error('normalize_data:UnknownMethod', ...
                'Unknown normalization method: %s', method);
    end
end

function denormalized_data = denormalize_data(normalized_data, params)
    % DENORMALIZE_DATA - Reverse normalization
    
    switch lower(params.method)
        case 'zscore'
            denormalized_data = normalized_data .* params.std + params.mean;
            
        case 'minmax'
            range = params.max - params.min;
            denormalized_data = normalized_data .* range + params.min;
            
        case 'maxabs'
            denormalized_data = normalized_data .* params.max_abs;
            
        otherwise
            error('denormalize_data:UnknownMethod', ...
                'Unknown normalization method: %s', params.method);
    end
end

function [X_train, X_test, y_train, y_test] = split_data(X, y, opts)
    % SPLIT_DATA - Split data into training and testing sets
    
    if isfield(opts, 'ratio')
        train_ratio = opts.ratio;
    else
        train_ratio = 0.8;
    end
    
    if isfield(opts, 'shuffle')
        do_shuffle = opts.shuffle;
    else
        do_shuffle = true;
    end
    
    num_samples = size(X, 1);
    
    % Create indices
    if do_shuffle
        idx = randperm(num_samples);
    else
        idx = 1:num_samples;
    end
    
    % Split
    train_size = round(train_ratio * num_samples);
    train_idx = idx(1:train_size);
    test_idx = idx(train_size+1:end);
    
    X_train = X(train_idx, :);
    X_test = X(test_idx, :);
    
    if size(y, 1) == num_samples
        y_train = y(train_idx, :);
        y_test = y(test_idx, :);
    else
        y_train = y(:, train_idx);
        y_test = y(:, test_idx);
    end
end

function one_hot = one_hot_encode(labels, num_classes)
    % ONE_HOT_ENCODE - Convert labels to one-hot encoding
    %
    % Inputs:
    %   labels      - Label vector (N x 1) with values 0 to num_classes-1 or 1 to num_classes
    %   num_classes - Number of classes
    %
    % Outputs:
    %   one_hot - One-hot encoded matrix (N x num_classes)
    
    num_samples = length(labels);
    one_hot = zeros(num_samples, num_classes);
    
    % Handle both 0-indexed and 1-indexed labels
    min_label = min(labels);
    if min_label == 0
        % 0-indexed labels
        for i = 1:num_samples
            one_hot(i, labels(i) + 1) = 1;
        end
    else
        % 1-indexed labels
        for i = 1:num_samples
            one_hot(i, labels(i)) = 1;
        end
    end
end

function labels = one_hot_decode(one_hot)
    % ONE_HOT_DECODE - Convert one-hot encoding back to labels
    %
    % Returns 1-indexed labels
    
    [~, labels] = max(one_hot, [], 2);
end

function shuffled_data = shuffle_data(data, varargin)
    % SHUFFLE_DATA - Randomly shuffle data rows
    
    num_samples = size(data, 1);
    idx = randperm(num_samples);
    
    if iscell(data)
        shuffled_data = cell(size(data));
        for i = 1:length(data)
            if size(data{i}, 1) == num_samples
                shuffled_data{i} = data{i}(idx, :);
            else
                shuffled_data{i} = data{i};
            end
        end
    else
        shuffled_data = data(idx, :);
    end
end

function opts = parse_options(args)
    % PARSE_OPTIONS - Parse name-value pair arguments
    
    opts = struct();
    i = 1;
    while i <= length(args)
        if i == length(args)
            error('data_preprocessing:InvalidArgs', ...
                'Name-value pairs must come in pairs');
        end
        opts.(args{i}) = args{i+1};
        i = i + 2;
    end
end

