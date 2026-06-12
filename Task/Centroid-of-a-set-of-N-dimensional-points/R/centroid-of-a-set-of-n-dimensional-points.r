centroid <- function(...){
  coords_list <- list(...)
  nth_coords <- function(n) sapply(coords_list, function(v) v[n])
  parallel_coords <- lapply(seq_along(coords_list[[1]]), nth_coords)
  sapply(parallel_coords, mean)
}

test_points <- list(list(1, 2, 3),
                    list(c(8,2), c(0,0)),
                    list(c(5,5,0), c(10, 10, 0)),
                    list(c(1, 3.1, 6.5), c(-2, -5, 3.4), c(-7, -4, 9), c(2, 0, 3)),
                    list(c(0, 0, 0, 0, 1), c(0, 0, 0, 1, 0), c(0, 0, 1, 0, 0), c(0, 1, 0, 0, 0)))

lapply(test_points, function(l) do.call(centroid, l))

#Drawing
library(lattice)

draw_points <- c(test_points[[4]], list(do.call(centroid, test_points[[4]])))
draw_df <- sapply(draw_points, `+`) |> t() |> as.data.frame()
colnames(draw_df) <- c("x", "y", "z")
png("Centroid-R.png", width=1000, height=1000)
cloud(z ~ x*y, data=draw_df)
dev.off()
