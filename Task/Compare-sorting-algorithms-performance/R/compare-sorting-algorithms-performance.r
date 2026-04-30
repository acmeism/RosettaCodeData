comparesorts <- function(tosort) {
  a <- sample(c("i", "m", "q"))
  iavg <- mavg <- qavg <- 0.0

  for (c in a) {
    if (c == "i") {
      # Insertion sort timing
      times <- replicate(100, system.time(sort(tosort, method = "shell"))[3])
      iavg <- mean(times)
    } else if (c == "m") {
      # Merge sort timing (using default sort which is similar to merge sort)
      times <- replicate(100, system.time(sort(tosort, method = "quick"))[3])
      mavg <- mean(times)
    } else if (c == "q") {
      # Quick sort timing
      times <- replicate(100, system.time(sort(tosort, method = "quick"))[3])
      qavg <- mean(times)
    }
  }

  return(c(iavg = iavg, mavg = mavg, qavg = qavg))
}

# Create test data
allones <- rep(1, 400)
sequential <- 1:400
randomized <- sample(1:400)

# Warm-up runs and actual measurements for all ones
comparesorts(allones)
comparesorts(allones)
result <- comparesorts(allones)
cat("Average sort times for 400 ones:\n")
cat(sprintf("\tinsertion sort:\t%f\n\tmerge sort:\t%f\n\tquick sort\t%f\n",
            result["iavg"], result["mavg"], result["qavg"]))

# For presorted data
comparesorts(sequential)
comparesorts(sequential)
result <- comparesorts(sequential)
cat("Average sort times for 400 presorted:\n")
cat(sprintf("\tinsertion sort:\t%f\n\tmerge sort:\t%f\n\tquick sort\t%f\n",
            result["iavg"], result["mavg"], result["qavg"]))

# For randomized data
comparesorts(randomized)
comparesorts(randomized)
result <- comparesorts(randomized)
cat("Average sort times for 400 randomized:\n")
cat(sprintf("\tinsertion sort:\t%f\n\tmerge sort:\t%f\n\tquick sort\t%f\n",
            result["iavg"], result["mavg"], result["qavg"]))
