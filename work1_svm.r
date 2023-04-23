spect_train <- read.table("SPECT.train", sep = ",", header = FALSE)
spect_test <- read.table("SPECT.test", sep = ",", header = FALSE)
set.seed(333)

#SVM classify
library(e1071)

error_rates <- c()
costs <- seq(0.1, 5, 0.1)
for (n in  1:length(costs))
{
    svm_model <- svm(V1 ~ ., data = spect_train, kernel = "radial", type = "C-classification", cost = costs[n])
    svm_pred <- as.data.frame(predict(svm_model, newdata = spect_test))
    error_rates <- append(error_rates, sum(ifelse(svm_pred != spect_test[, 1], 1, 0)) / nrow(spect_test))
}
min_index = which(unlist(error_rates) == min(unlist(error_rates)))[1]

print(paste("The cost with minimum: ", costs[min_index], "Min value: ", error_rates[min_index]))