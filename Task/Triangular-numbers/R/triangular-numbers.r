simplex <- function(n, r) choose(n+r-1, r)
cat("First 30 figurate numbers:\n")
outer(1:30, c(2:4, 12), simplex) |>
  `colnames<-`(c("Triangular", "Tetrahedral", "Pentatopic", "12-simplex"))

rootnums <- c(7140, 21408696, 26728085384, 14545501785001)

tri_root <- function(x) 0.5*(sqrt(8*x+1)-1)
tet_root <- function(x) (3*x+sqrt(9*x^2-1/27))^(1/3)+(3*x-sqrt(9*x^2-1/27))^(1/3)-1
pent_root <- function(x) 0.5*(sqrt(5+4*sqrt(24*x+1))-3)

funs <- c(tri_root, tet_root, pent_root) |>
  sapply(function(f) function(x) sprintf("%.1f", f(x)))

sapply(funs, function(f) sapply(rootnums, f)) |>
  `rownames<-`(rootnums) |>
  `colnames<-`(c("tri-root", "tet-root", "pent-root")) |>
  print(quote = FALSE)
