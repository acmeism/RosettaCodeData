vec1 <- c(2, 5, 1, 3, 8, 9, 4, 6)
vec2 <- c(3, 5, 6, 2, 9, 8, 4)
vec3 <- c(1, 3, 7, 6, 9)

cle <- function(...) Reduce(intersect, list(...))

cle(vec1, vec2, vec3)
