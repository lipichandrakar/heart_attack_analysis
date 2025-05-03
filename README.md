# 🫀 Heart Disease Prediction

This project is a machine learning pipeline in R to predict the presence of heart disease using a cleaned and preprocessed dataset. It includes data cleaning, exploratory data analysis (EDA), feature encoding, model training using Random Forest, and performance evaluation.

---

## 📁 Project Structure

```
.
├── dataset/
│   ├── heart.csv               # Original dataset
│   └── heart_cleaned.csv       # Cleaned dataset saved after preprocessing
├── models/
│   └── heart_disease_model.rds # Trained Random Forest model
├── heart_disease_prediction.R  # Main R script
└── README.md                   # Project documentation
```

---


## 📊 Features Processed

- Missing value imputation (`chol`)
- Duplicate row removal
- Outlier handling (IQR method for `chol`)
- Numerical feature scaling
- Categorical variable encoding (`factor`)

---

## 📈 Model Details

- **Algorithm**: Random Forest
- **Library**: `randomForest`
- **Training/Test Split**: 80/20
- **Evaluation Metric**: Confusion Matrix & Accuracy

---

## 🧪 Example Output

- Target variable distribution
- Cholesterol histogram
- Correlation heatmap
- Accuracy (e.g., *Accuracy: 0.85*)
- Confusion matrix

---

## 💾 Output Artifacts

- `heart_cleaned.csv`: Cleaned version of the dataset
- `heart_disease_model.rds`: Saved model for future prediction or deployment

---

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).

---

