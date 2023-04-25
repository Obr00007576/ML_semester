spect_train <- read.table("SPECT.train", sep = ",", header = FALSE)
spect_test <- read.table("SPECT.test", sep = ",", header = FALSE)
set.seed(333)

y <- spect_train$V1
x <- data.matrix(spect_train[, 2:23])
library(glmnet)
lasso_model <- cv.glmnet(x, y, alpha = 1)
best_lambda <- lasso_model$lambda.min

best_model <- glmnet(x, y, lambda = best_lambda)
print(best_model$beta)