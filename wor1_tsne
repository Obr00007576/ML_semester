spect_train <- read.table("SPECT.train", sep = ",", header = FALSE)
spect_test <- read.table("SPECT.test", sep = ",", header = FALSE)
set.seed(333)

color_palette <- c("blue", "red")
colors <- color_palette[spect_train$V1 + 1]
library(Rtsne)
tsne_result <- Rtsne(as.matrix(spect_train[, 2:23]), dims = 2, perplexity = 6, check_duplicates = FALSE)
tsne_df <- data.frame(tsne_result$Y)

colnames(tsne_df) <- c("x", "y")

library(ggplot2)
plot(tsne_df$x, tsne_df$y, col = colors)