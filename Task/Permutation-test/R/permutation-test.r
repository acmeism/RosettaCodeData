library(gtools)

permutation.test <- function(treatment, control) {
  perms <- combinations(length(treatment) + length(control),
                        length(treatment),
                        c(treatment, control),
                        set = FALSE)
  p <- mean(rowMeans(perms) <= mean(treatment))
  c(under = p, over = 1-p)
}

permutation.test(c(85, 88, 75, 66, 25, 29, 83, 39, 97),
                 c(68, 41, 10, 49, 16, 65, 32, 92, 28, 98))
