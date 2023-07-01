library(gtools)
combinations(3, 2, c("iced", "jam", "plain"), set = FALSE, repeats.allowed = TRUE)
nrow(combinations(10, 3, repeats.allowed = TRUE))
