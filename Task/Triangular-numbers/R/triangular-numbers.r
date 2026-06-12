nth_rsimplex <- function(n, r) choose(n+r-1, r)
dims <- c(2, 3, 4, 12)
simplexnums <- lapply(dims, function(r) nth_rsimplex(1:30, r))
names(simplexnums) <- c("Triangular numbers",
                        "Tetrahedral numbers",
                        "Pentatopic numbers",
                        "12-simplex numbers")
print(simplexnums)

rootnums <- c(7140, 21408696, 26728085384, 14545501785001)

tri_root <- function(x) 0.5*(sqrt(8*x+1)-1)
tet_root <- function(x) (3*x+sqrt(9*x^2-1/27))^(1/3)+(3*x-sqrt(9*x^2-1/27))^(1/3)-1
pent_root <- function(x) 0.5*(sqrt(5+4*sqrt(24*x+1))-3)

roots <- sapply(c(tri_root, tet_root, pent_root), function(f) sapply(rootnums, f))
rownames(roots) <- rootnums
colnames(roots) <- c("tri-root","tet-root","pent-root")
print(roots)
