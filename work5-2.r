spect_train <- read.table("SPECT.train", sep = ",", header = FALSE)
spect_test <- read.table("SPECT.test", sep = ",", header = FALSE)

library(keras)
library(tensorflow)
set.seed(333)

dimm = 8

add_noise <- function(x, noise_factor = 0.3) 
{
    x_noisy <- x + noise_factor * matrix(rnorm(nrow(x) * ncol(x)), nrow = nrow(x))
    return(x_noisy)
}

x_train <- data.matrix(spect_train[, 2:23])
x_train_x_noisy <- add_noise(x = x_train)

y_train <- data.matrix(spect_train[, 1])
x_test <- data.matrix(spect_test[, -1])
y_test <- data.matrix(spect_test[, 1])

model <- keras_model_sequential() %>%
    layer_dense(units = 64, activation = "relu", input_shape = ncol(x_train)) %>%
    layer_dense(units = 32, activation = "relu") %>%
    layer_dense(units = dimm, activation = "relu") %>%
    layer_dense(units = 32, activation = "relu") %>%
    layer_dense(units = 64, activation = "relu") %>%
    layer_dense(units = ncol(x_train), activation = "sigmoid")

model %>% compile(
  loss = "mse",
  optimizer = 'adam'
)

model %>% fit(
  x_train_x_noisy, x_train,
  epochs = 200,
  batch_size = 32,
  shuffle = TRUE
)


encoder <- keras_model(inputs = model$layers[[1]]$input, outputs = model$layers[[3]]$output)
x_train_encoded <- predict(encoder, x_train)
ndata <- data.frame(x_train_encoded, y_train)

library(e1071)

svm_model <- svm(y_train ~ ., data = ndata, kernel = "radial", type = "C-classification", cost = 0.7)
svm_pred_train <- as.data.frame(predict(svm_model, newdata = ndata))
error_rate_train <- sum(ifelse(svm_pred_train != ndata[, dimm+1], 1, 0)) / nrow(ndata)

x_test_encoded <- predict(encoder, x_test)
ndata_test <- data.frame(x_test_encoded, y_test)
svm_pred_test <- as.data.frame(predict(svm_model, newdata = ndata_test))
error_rate_test <- sum(ifelse(svm_pred_test != ndata_test[, dimm+1], 1, 0)) / nrow(ndata_test)

print(paste("Train error", error_rate_train))
print(paste("Test error", error_rate_test))