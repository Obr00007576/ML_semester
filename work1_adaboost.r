spect_train <- read.table("SPECT.train", sep = ",", header = FALSE)
spect_test <- read.table("SPECT.test", sep = ",", header = FALSE)
spect_train$V1 <- as.factor(spect_train$V1)
spect_test$V1 <- as.factor(spect_test$V1)
set.seed(333)

#Adaboost classify
library(adabag)

n_trees <- seq(101, 300, by = 10)
error_list <- list()
ada_model <- boosting(V1 ~ ., data = spect_train)
for (n in n_trees)
{
    ada_model <- boosting(V1 ~ ., data = spect_train, mfinal = n)
    ada_pred <- predict.boosting(ada_model, newdata = spect_test)
    error_rate <- sum(ifelse(ada_pred$class != spect_test[, 1], 1, 0)) / nrow(spect_test)
    error_list[[as.character(n)]] <- error_rate
}

#plot(n_trees, sapply(error_list, unlist), type = "b", xlab = "Number of trees", ylab = "Test error")

min_index = which(unlist(error_list) == min(unlist(error_list)))[1]
print(paste("The cost with minimum: ", n_trees[min_index], "Min value: ", error_list[min_index]))