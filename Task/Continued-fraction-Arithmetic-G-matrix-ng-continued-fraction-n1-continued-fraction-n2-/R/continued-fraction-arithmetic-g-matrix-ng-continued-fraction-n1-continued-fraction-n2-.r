library(R6)

# Abstract-like base class for MatrixNG (not truly abstract in R, but we use it as base)
MatrixNG <- R6Class("MatrixNG",
  public = list(
    cfn = NULL,
    thisterm = NULL,
    haveterm = NULL,
    initialize = function() {
      stop("MatrixNG is abstract; use NG4 or NG8.")
    }
  )
)

# NG4 class
NG4 <- R6Class("NG4",
  inherit = MatrixNG,
  public = list(
    a1 = NULL,
    a = NULL,
    b1 = NULL,
    b = NULL,
    initialize = function(a1, a, b1, b) {
      self$cfn <- 0L
      self$thisterm <- 0L
      self$haveterm <- FALSE
      self$a1 <- as.integer(a1)
      self$a <- as.integer(a)
      self$b1 <- as.integer(b1)
      self$b <- as.integer(b)
    }
  )
)

# NG8 class
NG8 <- R6Class("NG8",
  inherit = MatrixNG,
  public = list(
    a12 = NULL,
    a1 = NULL,
    a2 = NULL,
    a = NULL,
    b12 = NULL,
    b1 = NULL,
    b2 = NULL,
    b = NULL,
    initialize = function(a12, a1, a2, a, b12, b1, b2, b) {
      self$cfn <- 0L
      self$thisterm <- 0L
      self$haveterm <- FALSE
      self$a12 <- as.integer(a12)
      self$a1 <- as.integer(a1)
      self$a2 <- as.integer(a2)
      self$a <- as.integer(a)
      self$b12 <- as.integer(b12)
      self$b1 <- as.integer(b1)
      self$b2 <- as.integer(b2)
      self$b <- as.integer(b)
    }
  )
)

# ContinuedFraction base class
ContinuedFraction <- R6Class("ContinuedFraction",
  public = list(
    initialize = function() {
      stop("ContinuedFraction is abstract; use R2cf or NG.")
    }
  )
)

# R2cf class
R2cf <- R6Class("R2cf",
  inherit = ContinuedFraction,
  public = list(
    n1 = NULL,
    n2 = NULL,
    initialize = function(n1, n2) {
      self$n1 <- as.integer(n1)
      self$n2 <- as.integer(n2)
    },
    nextterm = function() {
      term <- self$n1 %/% self$n2
      temp_n1 <- self$n2
      self$n2 <- self$n1 - term * self$n2
      self$n1 <- temp_n1
      return(term)
    },
    moreterms = function() {
      return(abs(self$n2) > 0L)
    }
  )
)

# NG class (wrapper for MatrixNG + ContinuedFraction vector)
NG <- R6Class("NG",
  inherit = ContinuedFraction,
  public = list(
    ng = NULL,
    n = NULL,
    initialize = function(ng, ...) {
      dots <- list(...)
      if (length(dots) == 1) {
        self$n <- list(dots[[1]])
      } else if (length(dots) == 2) {
        self$n <- list(dots[[1]], dots[[2]])
      } else {
        stop("NG expects 1 or 2 ContinuedFraction objects")
      }
      self$ng <- ng
    },
    nextterm = function() {
      self$ng$haveterm <- FALSE
      return(self$ng$thisterm)
    },
    moreterms = function() {
      while (needterm(self$ng)) {
        if (self$n[[self$ng$cfn + 1]]$moreterms()) {
          consumeterm(self$ng, self$n[[self$ng$cfn + 1]]$nextterm())
        } else {
          consumeterm(self$ng)
        }
      }
      return(self$ng$haveterm)
    }
  )
)

# Needterm and Consumeterm functions (dispatch via class)

needterm <- function(m) {
  UseMethod("needterm")
}

consumeterm <- function(m, n = NULL) {
  if (missing(n)) {
    UseMethod("consumeterm", m)
  } else {
    UseMethod("consumeterm_n", m)
  }
}

# NG4 methods
needterm.NG4 <- function(m) {
  if (m$b1 == 0L && m$b == 0L) return(FALSE)
  if (m$b1 == 0L || m$b == 0L) return(TRUE)
  thisterm <- m$a %/% m$b
  if (thisterm != m$a1 %/% m$b1) return(TRUE)
  # update state
  m$a <- m$b
  m$b <- m$a - m$b * thisterm  # Wait! This is wrong — fix order with temp
  # Correction: must use temp variables to avoid overwriting
  temp_a <- m$a
  temp_b <- m$b
  m$a <- temp_b
  m$b <- temp_a - temp_b * thisterm

  temp_a1 <- m$a1
  temp_b1 <- m$b1
  m$a1 <- temp_b1
  m$b1 <- temp_a1 - temp_b1 * thisterm
  m$haveterm <- TRUE
  m$thisterm <- thisterm
  return(FALSE)
}

consumeterm.NG4 <- function(m) {
  m$a <- m$a1
  m$b <- m$b1
}

consumeterm_n.NG4 <- function(m, n) {
  temp_a <- m$a
  temp_a1 <- m$a1
  m$a <- temp_a1
  m$a1 <- temp_a + temp_a1 * n

  temp_b <- m$b
  temp_b1 <- m$b1
  m$b <- temp_b1
  m$b1 <- temp_b + temp_b1 * n
}

# NG8 methods
needterm.NG8 <- function(m) {
  if (m$b1 == 0L && m$b == 0L && m$b2 == 0L && m$b12 == 0L) return(FALSE)
  if (m$b == 0L) {
    m$cfn <- if (m$b2 == 0L) 0L else 1L
    return(TRUE)
  } else if (m$b2 == 0L) {
    m$cfn <- 1L
    return(TRUE)
  } else if (m$b1 == 0L) {
    m$cfn <- 0L
    return(TRUE)
  }

  ab <- m$a / m$b
  a1b1 <- m$a1 / m$b1
  a2b2 <- m$a2 / m$b2

  if (m$b12 == 0L) {
    m$cfn <- if (abs(a1b1 - ab) > abs(a2b2 - ab)) 0L else 1L
    return(TRUE)
  }

  thisterm <- m$a %/% m$b
  a1_div <- m$a1 %/% m$b1
  a2_div <- m$a2 %/% m$b2
  a12_div <- m$a12 %/% m$b12

  if (thisterm == a1_div && thisterm == a2_div && thisterm == a12_div) {
    # Update all using temp vars to avoid overwrite
    temp_a <- m$a; temp_b <- m$b
    m$a <- temp_b
    m$b <- temp_a - temp_b * thisterm

    temp_a1 <- m$a1; temp_b1 <- m$b1
    m$a1 <- temp_b1
    m$b1 <- temp_a1 - temp_b1 * thisterm

    temp_a2 <- m$a2; temp_b2 <- m$b2
    m$a2 <- temp_b2
    m$b2 <- temp_a2 - temp_b2 * thisterm

    temp_a12 <- m$a12; temp_b12 <- m$b12
    m$a12 <- temp_b12
    m$b12 <- temp_a12 - temp_b12 * thisterm
    m$haveterm <- TRUE
    m$thisterm <- thisterm
    return(FALSE)
  }

  m$cfn <- if (abs(a1b1 - ab) > abs(a2b2 - ab)) 0L else 1L
  return(TRUE)
}

consumeterm.NG8 <- function(m) {
  if (m$cfn == 0L) {
    m$a <- m$a1
    m$a2 <- m$a12
    m$b <- m$b1
    m$b2 <- m$b12
  } else {
    m$a <- m$a2
    m$a1 <- m$a12
    m$b <- m$b2
    m$b1 <- m$b12
  }
}

consumeterm_n.NG8 <- function(m, n) {
  if (m$cfn == 0L) {
    temp_a <- m$a; temp_a1 <- m$a1
    m$a <- temp_a1
    m$a1 <- temp_a + temp_a1 * n

    temp_a2 <- m$a2; temp_a12 <- m$a12
    m$a2 <- temp_a12
    m$a12 <- temp_a2 + temp_a12 * n

    temp_b <- m$b; temp_b1 <- m$b1
    m$b <- temp_b1
    m$b1 <- temp_b + temp_b1 * n

    temp_b2 <- m$b2; temp_b12 <- m$b12
    m$b2 <- temp_b12
    m$b12 <- temp_b2 + temp_b12 * n
  } else {
    temp_a <- m$a; temp_a2 <- m$a2
    m$a <- temp_a2
    m$a2 <- temp_a + temp_a2 * n

    temp_a1 <- m$a1; temp_a12 <- m$a12
    m$a1 <- temp_a12
    m$a12 <- temp_a1 + temp_a12 * n

    temp_b <- m$b; temp_b2 <- m$b2
    m$b <- temp_b2
    m$b2 <- temp_b + temp_b2 * n

    temp_b1 <- m$b1; temp_b12 <- m$b12
    m$b1 <- temp_b12
    m$b12 <- temp_b1 + temp_b12 * n
  }
}

# Test function
testcfs <- function() {
  test <- function(desc, cfs) {
    cat("TESTING -> ", desc, "\n", sep = "")
    for (cf in cfs) {
      while (cf$moreterms()) {
        cat(cf$nextterm(), " ")
      }
      cat("\n")
    }
    cat("\n")
  }

  a <- NG8$new(0L, 1L, 1L, 0L, 0L, 0L, 0L, 1L)
  n2 <- R2cf$new(22L, 7L)
  n1 <- R2cf$new(1L, 2L)
  a3 <- NG4$new(2L, 1L, 0L, 2L)
  n3 <- R2cf$new(22L, 7L)
  test("[3;7] + [0;2]", list(NG$new(a, n1, n2), NG$new(a3, n3)))

  b <- NG8$new(1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L)
  b1 <- R2cf$new(13L, 11L)
  b2 <- R2cf$new(22L, 7L)
  test("[1;5,2] * [3;7]", list(NG$new(b, b1, b2), R2cf$new(286L, 77L)))

  c_obj <- NG8$new(0L, 1L, -1L, 0L, 0L, 0L, 0L, 1L)
  c1 <- R2cf$new(13L, 11L)
  c2 <- R2cf$new(22L, 7L)
  test("[1;5,2] - [3;7]", list(NG$new(c_obj, c1, c2), R2cf$new(-151L, 77L)))

  d <- NG8$new(0L, 1L, 0L, 0L, 0L, 0L, 1L, 0L)
  d1 <- R2cf$new(22L * 22L, 7L * 7L)
  d2 <- R2cf$new(22L, 7L)
  test("Divide [] by [3;7]", list(NG$new(d, d1, d2)))

  na <- NG8$new(0L, 1L, 1L, 0L, 0L, 0L, 0L, 1L)
  a1 <- R2cf$new(2L, 7L)
  a2 <- R2cf$new(13L, 11L)
  aa <- NG$new(na, a1, a2)
  nb <- NG8$new(0L, 1L, -1L, 0L, 0L, 0L, 0L, 1L)
  b3 <- R2cf$new(2L, 7L)
  b4 <- R2cf$new(13L, 11L)
  bb <- NG$new(nb, b3, b4)
  nc <- NG8$new(1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L)
  desc <- "([0;3,2] + [1;5,2]) * ([0;3,2] - [1;5,2])"
  test(desc, list(NG$new(nc, aa, bb), R2cf$new(-7797L, 5929L)))
}

# Run tests
testcfs()
