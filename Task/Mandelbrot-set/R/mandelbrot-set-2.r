#install.packages("caTools") # install external package (if missing)
library(caTools)             # external package providing write.gif function
jet.colors <- colorRampPalette(c("red", "blue", "#007FFF", "cyan", "#7FFF7F",
                                 "yellow", "#FF7F00", "red", "#7F0000"))
dx <- 800                    # define width
dy <- 600                    # define height
C  <- complex(real = rep(seq(-2.5, 1.5, length.out = dx), each = dy),
              imag = rep(seq(-1.5, 1.5, length.out = dy), dx))
C <- matrix(C, dy, dx)       # reshape as square matrix of complex numbers
Z <- 0                       # initialize Z to zero
X <- array(0, c(dy, dx, 20)) # initialize output 3D array
for (k in 1:20) {            # loop with 20 iterations
  Z <- Z^2 + C               # the central difference equation
  X[, , k] <- exp(-abs(Z))   # capture results
}
write.gif(X, "Mandelbrot.gif", col = jet.colors, delay = 100)
