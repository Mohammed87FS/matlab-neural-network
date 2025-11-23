# How to Predict Car Prices

## 🚀 Quick Start

### Method 1: Simple Prediction Script (Easiest)

1. **Edit the car details** in `predict_car_price.m`:

```matlab
% Open predict_car_price.m and edit these lines:
car.kms_driven = 45000;              % Your car's kilometers
car.fuel_type = 'Petrol';            % Petrol, Diesel, CNG, LPG, Electric
car.transmission = 'Manual';         % Manual or Automatic
car.ownership = '1st';               % 1st, 2nd, 3rd, 4th or Above
car.manufacture_year = 2018;         % Manufacturing year
car.engine_cc = 1197;                % Engine size in CC
car.seats = 5;                       % Number of seats
```

2. **Run the script**:

```matlab
predict_car_price
```

3. **Get your prediction!**

```
=========================================
PREDICTED PRICE
=========================================
₹8.45 Lakhs (₹8,45,000)
=========================================

Estimated Range (±15%):
  Low:  ₹7.18 Lakhs
  High: ₹9.72 Lakhs
```

---

## 📋 Method 2: Predict from CSV File

To predict prices for multiple cars from a CSV file:

```matlab
% Load your CSV with car data
new_cars = readtable('your_cars.csv');

% Load trained model
load('models/car_price_model.mat', 'model');

% For each car, preprocess and predict
% (You'll need to preprocess the same way as training)
```

---

## 💻 Method 3: Use in Your Own Code

### Basic Example:

```matlab
% 1. Load the model
load('models/car_price_model.mat', 'model');

% 2. Prepare your features (10 features in this order):
% [kms, fuel_onehot(4), transmission(1), ownership(1), age(1), engine(1), seats(1)]
features = [45000, 0, 0, 0, 1, 0, 1, 7, 1197, 5];  % Example

% 3. Normalize features (z-score)
features = (features - mean(features)) ./ std(features);

% 4. Predict (returns log-transformed price)
prediction_log = predict_regression(model, features);

% 5. Convert to actual price in Lakhs
predicted_price_lakhs = expm1(prediction_log);

fprintf('Predicted Price: ₹%.2f Lakhs\n', predicted_price_lakhs);
```

---

## 🔧 Feature Details

Your input must have **10 features** in this exact order:

| # | Feature | Description | Example |
|---|---------|-------------|---------|
| 1 | Kilometers | Kilometers driven (cap at 300k) | 45000 |
| 2-5 | Fuel Type | One-hot encoded (4 features) | [0,0,0,1] for Petrol |
| 6 | Transmission | 0=Manual, 1=Automatic | 0 |
| 7 | Ownership | 1=1st, 2=2nd, 3=3rd, 4=4th+ | 1 |
| 8 | Age | Current year - manufacture year | 7 |
| 9 | Engine | Engine capacity in CC | 1197 |
| 10 | Seats | Number of seats | 5 |

### Fuel Type One-Hot Encoding:

| Fuel Type | Feature 2 | Feature 3 | Feature 4 | Feature 5 |
|-----------|-----------|-----------|-----------|-----------|
| CNG | 1 | 0 | 0 | 0 |
| Diesel | 0 | 1 | 0 | 0 |
| Electric | 0 | 0 | 1 | 0 |
| LPG | 0 | 0 | 0 | 1 |
| Petrol | 0 | 0 | 0 | 0 |

---

## 📊 Understanding Predictions

### Price Output:
- Predictions are in **Lakhs** (₹1 Lakh = ₹100,000)
- Model was trained with log transformation
- Always convert: `actual_price = expm1(prediction)`

### Accuracy:
- **MAE: ₹4.25 Lakhs** - Average error
- **Best for:** Cars priced ₹3-20 Lakhs
- **Less accurate for:** Luxury cars > ₹50 Lakhs

### Uncertainty:
- Typical uncertainty: ±15-20%
- Lower for common cars
- Higher for rare/luxury cars

---

## ⚠️ Important Notes

1. **Preprocessing is Critical**
   - Must normalize features (z-score)
   - Must use log transformation for output
   - Must match training preprocessing exactly

2. **Feature Order Matters**
   - Features must be in exact same order as training
   - One-hot encoding must match training

3. **Handle Edge Cases**
   - Cap kilometers at 300,000 km
   - Cap age at 30 years
   - Handle missing values with median/mode

---

## 🎯 Example Predictions

```matlab
% Example 1: Budget Car
car1.kms_driven = 30000;
car1.fuel_type = 'Petrol';
car1.transmission = 'Manual';
car1.ownership = '1st';
car1.manufacture_year = 2020;
car1.engine_cc = 998;
car1.seats = 5;
% Expected: ₹4-6 Lakhs

% Example 2: Mid-Range Car
car2.kms_driven = 50000;
car2.fuel_type = 'Diesel';
car2.transmission = 'Automatic';
car2.ownership = '1st';
car2.manufacture_year = 2018;
car2.engine_cc = 1498;
car2.seats = 5;
% Expected: ₹10-15 Lakhs

% Example 3: Older Car
car3.kms_driven = 120000;
car3.fuel_type = 'Petrol';
car3.transmission = 'Manual';
car3.ownership = '3rd';
car3.manufacture_year = 2010;
car3.engine_cc = 1197;
car3.seats = 5;
% Expected: ₹2-4 Lakhs
```

---

## 🔄 Retrain Model

If you want to retrain with new data:

```matlab
% 1. Add your new data to data/car_price.csv
% 2. Run training again
train_car_price_model

% Model will be updated at models/car_price_model.mat
```

---

## ❓ Troubleshooting

**Q: Getting negative predictions?**
- Shouldn't happen with current model
- If it does: `price = max(expm1(prediction), 0)`

**Q: Predictions seem wrong?**
- Check feature preprocessing
- Verify feature order
- Ensure normalization is applied
- Check if car type was in training data

**Q: How to improve accuracy?**
- Add more training data
- Include more features (brand, model, location)
- Tune hyperparameters
- Train longer

---

## 📞 Support

For issues or questions:
1. Check feature preprocessing
2. Verify input format
3. Review training logs
4. Ensure model file exists

Happy predicting! 🚗💰

