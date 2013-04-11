grayscalesImage <- function(nrow = 4) {
  X <- matrix(NA, nrow = nrow, ncol = 2^(nrow + 2))
  for (i in 1:nrow) {
    X[i, ] <- rep(1:2^(i + 2), each = 2^(nrow - i)) / 2^(i + 2)
    if (i %% 2 == 0) X[i, ] <- rev(X[i, ])
  }
  par(mar = rep(0, 4))
  image(t(X[nrow:1, ]), col = gray(1:ncol(X) / ncol(X)), axes = FALSE)
}
## Example ##
grayscalesImage(6)  # produces image shown in screenshot to the right
