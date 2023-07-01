deg2rad <- function(x) {
  x * pi/180
}

rad2deg <- function(x) {
  x * 180/pi
}

deg2vec <- function(x) {
  c(sin(deg2rad(x)), cos(deg2rad(x)))
}

vec2deg <- function(x) {
  res <- rad2deg(atan2(x[1], x[2]))
  if (res < 0) {
    360 + res
  } else {
    res
  }
}

mean_vec <- function(x) {
  y <- lapply(x, deg2vec)
  Reduce(`+`, y)/length(y)
}

mean_deg <- function(x) {
  vec2deg(mean_vec(x))
}

mean_deg(c(350, 10))
mean_deg(c(90, 180, 270, 360))
mean_deg(c(10, 20, 30))
