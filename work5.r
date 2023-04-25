spect_train <- read.table("SPECT.train", sep = ",", header = FALSE)
spect_test <- read.table("SPECT.test", sep = ",", header = FALSE)

library(keras)
library(tensorflow)
set.seed(333)

dimm = 8

# x_train <- data.matrix(spect_train[, -1])
# y_train <- data.matrix(spect_train[, 1])
# x_test <- data.matrix(spect_test[, -1])
# y_test <- data.matrix(spect_test[, 1])

# model <- keras_model_sequential()
# model %>%
#     layer_dense(units = 64, activation = "relu", input_shape = ncol(x_train)) %>%
#     layer_dense(units = 32, activation = "relu") %>%
#     layer_dense(units = dimm, activation = "relu") %>%
#     layer_dense(units = 32, activation = "relu") %>%
#     layer_dense(units = 64, activation = "relu") %>%
#     layer_dense(units = ncol(x_train), activation = "sigmoid")


# model %>% compile(
#   loss = "mse",
#   optimizer = 'adam'
# )

# model %>% fit(
#   x_train, x_train,
#   epochs = 200,
#   batch_size = 32,
#   shuffle = TRUE
# )

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

library(Rtsne)
tsne_result <- Rtsne(as.matrix(spect_train[, 1:dimm]), dims = 2, perplexity = 7, check_duplicates = FALSE)
tsne_df <- data.frame(tsne_result$Y)
color_palette <- c("blue", "red")
colors <- color_palette[ndata$y_train + 1]
colnames(tsne_df) <- c("x", "y")
plot(tsne_df$x, tsne_df$y, col = colors)