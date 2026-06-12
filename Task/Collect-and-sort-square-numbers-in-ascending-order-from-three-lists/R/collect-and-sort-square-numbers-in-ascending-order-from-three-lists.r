vec1 <- c(3, 4, 34, 25, 9, 12, 36, 56, 36)
vec2 <- c(2, 8, 81, 169, 34, 55, 76, 49, 7)
vec3 <- c(75, 121, 75, 144, 35, 16, 46, 35)

issquare <- function(n) sqrt(n)%%1==0
Filter(issquare, c(vec1, vec2, vec3)) |> sort()
