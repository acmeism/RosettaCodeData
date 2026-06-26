options(digits = 8, scipen = 10)

test_angles <- c(-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000)
circle <- c("deg" = 360, "grad" = 400, "mil" = 6400, "rad" = 2*pi)

x2x <- function(u) function(a) sign(a)*(abs(a) %% circle[u])
x2y <- function(ux, uy) function(a) outer(a, circle[uy]/circle[ux])

lapply(
  names(circle),
  function(u) {
    cbind(
      test_angles |> as.matrix() |> `colnames<-`(paste0(u, "_unnorm")),
      x2x(u)(test_angles) |> x2y(u, names(circle))()
    ) |> as.data.frame()
  }
) |> setNames(names(circle))
