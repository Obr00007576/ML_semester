spect_train <- read.table("SPECT.train", sep = ",", header = FALSE)
clust <- spect_train[, -1]
set.seed(333)

d <- dist(clust, method = "binary")
ward <- hclust(d, method = "ward.D2")
plot(ward, sub = "Ward method")

sub_grp <- as.data.frame(ifelse(cutree(ward, k = 2) == 1, 1, 0))

error_rate <- sum(ifelse(sub_grp != spect_train[, 1], 1, 0)) / nrow(sub_grp)
print(paste("erorr_rate", error_rate))