# Point constructor
Point <- function(x, y) {
  structure(list(x = x, y = y), class = "Point")
}

# Comparison operators for Point
point_equal <- function(p1, p2) {
  p1$x == p2$x && p1$y == p2$y
}

point_less <- function(p1, p2) {
  if (p1$x == p2$x) {
    return(p1$y < p2$y)
  }
  return(p1$x < p2$x)
}

# Function to flip points
flipped <- function(points) {
  lapply(points, function(p) Point(-p$x, -p$y))
}

# Quickselect algorithm
quickselect <- function(ls, index, lo = 1, hi = NULL) {
  if (is.null(hi)) hi <- length(ls)

  if (lo == hi) return(ls[[lo]])

  pivot <- lo + sample(0:(hi - lo), 1)
  temp <- ls[[lo]]
  ls[[lo]] <- ls[[pivot]]
  ls[[pivot]] <- temp

  cur <- lo
  for (run in (lo + 1):hi) {
    if (point_less(ls[[run]], ls[[lo]])) {
      cur <- cur + 1
      temp <- ls[[cur]]
      ls[[cur]] <- ls[[run]]
      ls[[run]] <- temp
    }
  }

  temp <- ls[[cur]]
  ls[[cur]] <- ls[[lo]]
  ls[[lo]] <- temp

  if (index < cur) {
    return(quickselect(ls, index, lo, cur - 1))
  } else if (index > cur) {
    return(quickselect(ls, index, cur + 1, hi))
  } else {
    return(ls[[cur]])
  }
}

# Quickselect for numeric values
quickselect_numeric <- function(ls, index, lo = 1, hi = NULL) {
  if (is.null(hi)) hi <- length(ls)

  if (lo == hi) return(ls[lo])

  pivot <- lo + sample(0:(hi - lo), 1)
  temp <- ls[lo]
  ls[lo] <- ls[pivot]
  ls[pivot] <- temp

  cur <- lo
  for (run in (lo + 1):hi) {
    if (ls[run] < ls[lo]) {
      cur <- cur + 1
      temp <- ls[cur]
      ls[cur] <- ls[run]
      ls[run] <- temp
    }
  }

  temp <- ls[cur]
  ls[cur] <- ls[lo]
  ls[lo] <- temp

  if (index < cur) {
    return(quickselect_numeric(ls, index, lo, cur - 1))
  } else if (index > cur) {
    return(quickselect_numeric(ls, index, cur + 1, hi))
  } else {
    return(ls[cur])
  }
}

# Bridge function to find the upper bridge of the convex hull
bridge <- function(points, vertical_line) {
  candidates <- list()

  if (length(points) == 2) {
    return(list(points[[1]], points[[2]]))
  }

  pairs <- list()
  modify_s <- points

  while (length(modify_s) >= 2) {
    p1 <- modify_s[[length(modify_s)]]
    modify_s <- modify_s[-length(modify_s)]
    p2 <- modify_s[[length(modify_s)]]
    modify_s <- modify_s[-length(modify_s)]

    if (point_less(p1, p2)) {
      pairs[[length(pairs) + 1]] <- list(p1, p2)
    } else {
      pairs[[length(pairs) + 1]] <- list(p2, p1)
    }
  }

  if (length(modify_s) > 0) {
    candidates[[length(candidates) + 1]] <- modify_s[[1]]
  }

  slopes <- numeric()
  i <- 1
  while (i <= length(pairs)) {
    pi <- pairs[[i]][[1]]
    pj <- pairs[[i]][[2]]

    if (pi$x == pj$x) {
      candidates[[length(candidates) + 1]] <- if (pi$y > pj$y) pi else pj
      pairs <- pairs[-i]
    } else {
      slopes <- c(slopes, (pi$y - pj$y) / (pi$x - pj$x))
      i <- i + 1
    }
  }

  if (length(slopes) == 0) {
    if (length(candidates) >= 2) {
      return(list(candidates[[1]], candidates[[2]]))
    }
    return(list(points[[1]], points[[2]]))
  }

  median_index <- floor(length(slopes) / 2) - (if (length(slopes) %% 2 == 0) 1 else 0) + 1
  median_slope <- quickselect_numeric(slopes, median_index)

  small <- list()
  equal <- list()
  large <- list()

  for (i in seq_along(slopes)) {
    if (slopes[i] < median_slope) {
      small[[length(small) + 1]] <- pairs[[i]]
    } else if (abs(slopes[i] - median_slope) < .Machine$double.eps) {
      equal[[length(equal) + 1]] <- pairs[[i]]
    } else {
      large[[length(large) + 1]] <- pairs[[i]]
    }
  }

  max_slope <- -Inf
  for (point in points) {
    max_slope <- max(max_slope, point$y - median_slope * point$x)
  }

  max_set <- Filter(function(point) {
    abs(point$y - median_slope * point$x - max_slope) < .Machine$double.eps
  }, points)

  left <- Reduce(function(a, b) if (point_less(a, b)) a else b, max_set)
  right <- Reduce(function(a, b) if (point_less(a, b)) b else a, max_set)

  if (left$x <= vertical_line && right$x > vertical_line) {
    return(list(left, right))
  }

  if (right$x <= vertical_line) {
    for (pair in large) {
      candidates[[length(candidates) + 1]] <- pair[[2]]
    }
    for (pair in equal) {
      candidates[[length(candidates) + 1]] <- pair[[2]]
    }
    for (pair in small) {
      candidates[[length(candidates) + 1]] <- pair[[1]]
      candidates[[length(candidates) + 1]] <- pair[[2]]
    }
  }

  if (left$x > vertical_line) {
    for (pair in small) {
      candidates[[length(candidates) + 1]] <- pair[[1]]
    }
    for (pair in equal) {
      candidates[[length(candidates) + 1]] <- pair[[1]]
    }
    for (pair in large) {
      candidates[[length(candidates) + 1]] <- pair[[1]]
      candidates[[length(candidates) + 1]] <- pair[[2]]
    }
  }

  bridge(candidates, vertical_line)
}

# Connect function to build the hull between two points
connect <- function(lower, upper, points) {
  if (point_equal(lower, upper)) {
    return(list(lower))
  }

  mid_index <- floor(length(points) / 2)

  max_left <- quickselect(points, mid_index)
  min_right <- quickselect(points, mid_index + 1)

  bridge_result <- bridge(points, (max_left$x + min_right$x) / 2.0)
  left <- bridge_result[[1]]
  right <- bridge_result[[2]]

  points_left <- list(left)
  points_right <- list(right)

  for (point in points) {
    if (point$x < left$x) {
      points_left[[length(points_left) + 1]] <- point
    } else if (point$x > right$x) {
      points_right[[length(points_right) + 1]] <- point
    }
  }

  left_result <- connect(lower, left, points_left)
  right_result <- connect(right, upper, points_right)

  c(left_result, right_result)
}

# Compute the upper hull
upper_hull <- function(points) {
  lower <- Reduce(function(a, b) if (point_less(a, b)) a else b, points)

  # Find the lowest point with the same x-coordinate as the minimum
  for (point in points) {
    if (point$x == lower$x && point$y > lower$y) {
      lower <- point
    }
  }

  upper <- Reduce(function(a, b) if (point_less(a, b)) b else a, points)

  filtered_points <- list(lower, upper)
  for (p in points) {
    if (lower$x < p$x && p$x < upper$x) {
      filtered_points[[length(filtered_points) + 1]] <- p
    }
  }

  connect(lower, upper, filtered_points)
}

# Compute the convex hull
convex_hull <- function(points) {
  upper <- upper_hull(points)

  flipped_points <- flipped(points)
  flipped_upper <- upper_hull(flipped_points)
  lower <- flipped(flipped_upper)

  result <- upper

  if (length(result) > 0 && length(lower) > 0 && point_equal(result[[length(result)]], lower[[1]])) {
    lower <- lower[-1]
  }

  if (length(result) > 0 && length(lower) > 0 && point_equal(result[[1]], lower[[length(lower)]])) {
    lower <- lower[-length(lower)]
  }

  c(result, lower)
}

# Main function to test the convex hull
testks <- function() {
  # Create points for a 2D projection of a 3D simplex
  points <- list(
    Point(0.0, 0.0),  # projection of [0.0, 0.0, 0.0]
    Point(1.0, 0.0),  # projection of [1.0, 0.0, 0.0]
    Point(0.0, 1.0),  # projection of [0.0, 1.0, 0.0]
    Point(0.5, 0.5)   # projection of [0.0, 0.0, 1.0]
  )

  cat("Input points:\n")
  for (p in points) {
    cat(sprintf("(%.1f, %.1f)\n", p$x, p$y))
  }

  hull <- convex_hull(points)

  cat("\nConvex hull points:\n")
  for (p in hull) {
    cat(sprintf("(%.1f, %.1f)\n", p$x, p$y))
  }
}

# Run the test program
testks()
