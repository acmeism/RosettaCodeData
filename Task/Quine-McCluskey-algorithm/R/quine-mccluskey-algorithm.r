# SetType class equivalent using R's reference classes
SetType <- setRefClass("SetType",
  fields = list(items = "character"),
  methods = list(
    initialize = function() {
      items <<- character(0)
    }
  )
)

# Convert integer to binary string
b2s <- function(i, vars) {
  s <- ""
  for (j in 1:vars) {
    s <- paste0(ifelse((bitwAnd(i, 1) == 1), "1", "0"), s)
    i <- bitwShiftR(i, 1)
  }
  return(s)
}

# Count '1' bits in string
bit_count <- function(s) {
  sum(strsplit(s, "")[[1]] == "1")
}

# Merge two strings according to QM rules
merge <- function(i, j) {
  len <- min(nchar(i), nchar(j))
  dif_cnt <- 0
  s <- ""

  for (k in 1:len) {
    a <- substr(i, k, k)
    b <- substr(j, k, k)

    if (a == 'X' || b == 'X') {
      if (a != b) {
        return("")
      }
      s <- paste0(s, a)
    } else if (a != b) {
      dif_cnt <- dif_cnt + 1
      if (dif_cnt > 1) {
        return("")
      }
      s <- paste0(s, 'X')
    } else {
      s <- paste0(s, a)
    }
  }
  return(s)
}

# Add item to set if not already present
add_to_set <- function(s, item) {
  if (!(item %in% s$items)) {
    s$items <- c(s$items, item)
  }
}

# Check if item is in set
in_set <- function(s, item) {
  item %in% s$items
}

# Union two sets
union_sets <- function(dest, src) {
  for (item in src$items) {
    add_to_set(dest, item)
  }
}

# Compute prime implicants
compute_primes <- function(cubes, vars, primes) {
  sigma <- lapply(0:vars, function(x) SetType$new())
  sigma_count <- 0

  for (j in 0:vars) {
    for (cube in cubes$items) {
      if (bit_count(cube) == j) {
        add_to_set(sigma[[j + 1]], cube)
      }
    }
    if (length(sigma[[j + 1]]$items) > 0) {
      sigma_count <- j + 1
    }
  }

  primes$items <- character(0)

  while (sigma_count > 0) {
    if (sigma_count == 1) {
      # Only one group left, all are prime implicants
      for (cube in sigma[[1]]$items) {
        add_to_set(primes, cube)
      }
      break
    }

    nsigma <- list()
    redundant <- SetType$new()

    for (i in 1:(sigma_count - 1)) {
      c1 <- sigma[[i]]
      c2 <- sigma[[i + 1]]
      nc <- SetType$new()

      if (length(c1$items) > 0 && length(c2$items) > 0) {
        for (a in c1$items) {
          for (b in c2$items) {
            m <- merge(a, b)
            if (m != "") {
              add_to_set(nc, m)
              add_to_set(redundant, a)
              add_to_set(redundant, b)
            }
          }
        }
      }

      if (length(nc$items) > 0) {
        nsigma[[length(nsigma) + 1]] <- nc
      }
    }

    for (i in 1:sigma_count) {
      if (length(sigma[[i]]$items) > 0) {
        for (cube in sigma[[i]]$items) {
          if (!in_set(redundant, cube)) {
            add_to_set(primes, cube)
          }
        }
      }
    }

    sigma_count <- length(nsigma)
    if (sigma_count > 0) {
      sigma <- nsigma
    }
  }
}

# Get active primes based on selection
active_primes <- function(cubesel, primes, result) {
  result$items <- character(0)
  s <- b2s(cubesel, length(primes$items))

  for (i in 1:length(primes$items)) {
    if (substr(s, i, i) == '1') {
      add_to_set(result, primes$items[i])
    }
  }
}

# Check if prime covers one
is_cover <- function(prime, one) {
  len <- min(nchar(prime), nchar(one))

  for (i in 1:len) {
    p <- substr(prime, i, i)
    o <- substr(one, i, i)
    if (p != 'X' && p != o) {
      return(FALSE)
    }
  }
  return(TRUE)
}

# Check if all ones are covered
is_full_cover <- function(all_primes, ones) {
  for (one in ones$items) {
    covered <- FALSE
    for (prime in all_primes$items) {
      if (is_cover(prime, one)) {
        covered <- TRUE
        break
      }
    }
    if (!covered) {
      return(FALSE)
    }
  }
  return(TRUE)
}

# Find minimal unate cover
unate_cover <- function(primes, ones, result) {
  min_count <- 1000
  min_sel <- -1
  active <- SetType$new()

  total <- bitwShiftL(1, length(primes$items))

  for (cubesel in 0:(total - 1)) {
    active_primes(cubesel, primes, active)
    if (is_full_cover(active, ones)) {
      cnt <- bit_count(b2s(cubesel, length(primes$items)))
      if (cnt < min_count) {
        min_count <- cnt
        min_sel <- cubesel
      }
    }
  }

  if (min_sel != -1) {
    active_primes(min_sel, primes, result)
  } else {
    result$items <- character(0)
  }
}

# Main Quine-McCluskey algorithm
qm <- function(ones, zeros, dc) {
  result <- SetType$new()

  if (length(ones) == 0 && length(zeros) == 0 && length(dc) == 0) {
    return(result)
  }

  max_val <- max(c(
    ifelse(length(ones) > 0, max(ones), 0),
    ifelse(length(zeros) > 0, max(zeros), 0),
    ifelse(length(dc) > 0, max(dc), 0)
  ))

  numvars <- ifelse(max_val == 0, 1, ceiling(log2(max_val + 1)))

  ones_set <- SetType$new()
  zeros_set <- SetType$new()
  dc_set <- SetType$new()

  for (val in ones) {
    add_to_set(ones_set, b2s(val, numvars))
  }
  for (val in zeros) {
    add_to_set(zeros_set, b2s(val, numvars))
  }
  for (val in dc) {
    add_to_set(dc_set, b2s(val, numvars))
  }

  cubes <- SetType$new()
  union_sets(cubes, ones_set)
  union_sets(cubes, dc_set)

  primes <- SetType$new()
  compute_primes(cubes, numvars, primes)

  unate_cover(primes, ones_set, result)
  return(result)
}

# Test function
testqm <- function() {
  ones <- c(1, 2, 5)
  zeros <- integer(0)
  dc <- c(0, 7)

  result <- qm(ones, zeros, dc)
  cat(paste(result$items, collapse = " "), "\n")
}

# Run test
testqm()
