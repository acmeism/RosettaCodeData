max_area <- 1000
half_max <- max_area / 2
areas <- rep(1, max_area) # Initialize areas with 1's

for (i in 1:max_area) {
  for (j in 1:half_max) {
    if (i * j > half_max) {
      break
    }
    for (k in 1:half_max) {
      area <- 2 * (i * j + i * k + j * k)
      if (area > max_area) {
        break
      }
      areas[area] <- 0 # Mark as not an O'Halloran number
    }
  }
}

# Print the O'Halloran numbers
cat("Even surface areas < NOT", max_area, "achievable by any regular integer-valued cuboid:\n")
for (n in 3:(max_area/2)) {
  if (areas[2*n] == 1) {
    cat(2*n, " ")
  }
}
cat("\n") # To ensure the output ends with a newline
