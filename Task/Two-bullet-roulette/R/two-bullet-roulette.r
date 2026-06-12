rotate <- function(v, n) {
  if (n == 0) v else c(tail(v, -n), head(v, n))
}

spin <- function(v) rotate(v, sample(6, 1))

roulette <- function(method = "D") {
  cylinder <- c(rep(0, 5), 1) |> #Bullet is loaded in the last position
    rotate(1) #Then cylinder is rotated once
  if (method %in% c("A", "B")) cylinder <- spin(cylinder)
  if (cylinder[6] == 1) cylinder <- rotate(cylinder, 1)
  cylinder[6] <- 1 #Load second bullet
  cylinder <- spin(cylinder) #Always spin before first shot
  if (cylinder[1] == 1) return(TRUE) #Fire first shot
  cylinder <- rotate(cylinder, 1)
  if (method %in% c("A", "C")) cylinder <- spin(cylinder)
  cylinder[1] == 1 #Fire second shot
}

for (method in LETTERS[1:4]) {
  results <- replicate(10000, roulette(method))
  cat("Method", method, "results in", mean(results), "chance of death\n")
}
