spiral_matrix <- function(n) {
    spiralv <- function(v) {
        n <- sqrt(length(v))
        if (n != floor(n))
            stop("length of v should be a square of an integer")
        if (n == 0)
            stop("v should be of positive length")
        if (n == 1)
            m <- matrix(v, 1, 1)
        else
            m <- rbind(v[1:n], cbind(spiralv(v[(2 * n):(n^2)])[(n - 1):1, (n - 1):1], v[(n + 1):(2 * n - 1)]))
        m
    }
    spiralv(1:(n^2))
}
