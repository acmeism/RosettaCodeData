permutation.test <- function(treatment, control) {
  perms <- combinations(length(treatment)+length(control),
                        length(treatment),
                        c(treatment, control),
                        set=FALSE)
  p <- mean(rowMeans(perms) <= mean(treatment))
  c(under=p, over=(1-p))
}
