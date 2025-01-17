# install Libraries
install.packages("car")
install.packages("car", repos = "https://cran.rstudio.com/")
install.packages("tidyverse")
install.packages("caret")
install.packages(c("ggplot2", "lattice"))
install.packages("randomForest")

# Load Libraries
library(readxl)
library(car)
library(tidyverse)
library(caret)
library(randomForest)
library(ggplot2)

# Load Dataset
data <- read.csv("dataset/heart.csv")

# Data Overview
print("Dataset Overview:")
print(str(data))
summary(data)

# Data Cleaning Steps

# 1. Check for missing values
if (sum(is.na(data)) > 0) {
  print("Handling missing values...")
  data$chol[is.na(data$chol)] <- mean(data$chol, na.rm = TRUE)  # Replace with mean
}

# 2. Remove duplicate rows
print("Removing duplicates...")
data <- data[!duplicated(data), ]

# 3. Handle outliers (e.g., for cholesterol column)
Q1 <- quantile(data$chol, 0.25)
Q3 <- quantile(data$chol, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
data <- data[data$chol >= lower_bound & data$chol <= upper_bound, ]

# 4. Standardize numerical columns
num_cols <- c("age", "trestbps", "chol", "thalach", "oldpeak")
data[num_cols] <- scale(data[num_cols])

# 5. Encode categorical variables
data$sex <- as.factor(data$sex)
data$cp <- as.factor(data$cp)
data$fbs <- as.factor(data$fbs)
data$restecg <- as.factor(data$restecg)
data$exang <- as.factor(data$exang)
data$slope <- as.factor(data$slope)
data$ca <- as.factor(data$ca)
data$thal <- as.factor(data$thal)

# Verify the cleaned dataset
print("Cleaned dataset summary:")
print(summary(data))


# Save the cleaned dataset
write.csv(data, "dataset/heart_cleaned.csv", row.names = FALSE)
print("Cleaned dataset saved as heart_cleaned.csv.")

# EDA: Target Variable Distribution
ggplot(data, aes(x = target)) +
  geom_bar(fill = "lightblue") +
  labs(
    title = "Target Variable Distribution",
    x = "Target (0 = No Heart Disease, 1 = Heart Disease)",
    y = "Count"
  ) +
  theme_minimal()


ggplot(data, aes(x = chol)) +
  geom_histogram(fill = "cornsilk3", bins = 30) +
  labs(
    title = "Cholesterol Distribution",
    x = "Cholesterol",
    y = "Frequency"
  ) +
  theme_minimal()

# Correlation Heatmap
cor_matrix <- cor(data[, sapply(data, is.numeric)])
heatmap(cor_matrix, main = "Correlation Heatmap", col = heat.colors(20))


# Split Data
set.seed(42)
trainIndex <- createDataPartition(data$target, p = 0.8, list = FALSE)
train <- data[trainIndex, ]
test <- data[-trainIndex, ]

# Check distribution
table(train$target)
table(test$target)


# Train Random Forest Model
set.seed(42)
rf_model <- randomForest(target ~ ., data = train, importance = TRUE, ntree = 100)

# View model summary
print(rf_model)


# Make Predictions
predictions <- predict(rf_model, newdata = test)

# Ensure levels match
predictions <- factor(predictions, levels = levels(as.factor(test$target)))

# Evaluate Performance
library(caret)
conf_matrix <- confusionMatrix(predictions, as.factor(test$target))
print(conf_matrix)

# View Accuracy
accuracy <- conf_matrix$overall["Accuracy"]
print(paste("Accuracy:", accuracy))

# Ensure 'models' directory exists
if (!dir.exists("models")) {
  dir.create("models")
}

# Save the model
saveRDS(rf_model, "models/heart_disease_model.rds")

