spect_train <- read.table("SPECT.train", sep = ",", header = FALSE)
spect_test <- read.table("SPECT.test", sep = ",", header = FALSE)
set.seed(333)

#Decision tree classify
library(rpart)
library(rpart.plot)

tree_model <- rpart(V1 ~ ., data = spect_train, method = "class")
tree_pred <- as.data.frame(rpart.predict(tree_model, newdata = spect_test[, 2:23], type = "class", cost = n))
error_rate <- sum(ifelse(tree_pred != spect_test[, 1], 1, 0)) / nrow(spect_test)

print(paste("Error rate: ", error_rate))