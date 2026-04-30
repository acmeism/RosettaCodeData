## ----- Constants (match Julia) -----
Nr <- c(3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3)
Nc <- c(3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2)

N0 <- integer(85)
# N2 is a list of nibble vectors (each length 16, values 0..15, LSB-first)
N2 <- vector("list", 85)
N3 <- rep("", 85)      # chars 'd','u','r','l'
N4 <- integer(85)

i  <- 1L
g  <- 8L
ee <- 2L
l  <- 4L
.n <- 1L  # scalar (Julia used a 1-element Vector{Int32})

## ----- Helpers for nibble representation -----
# Convert a 16-hex string like "fe169b4c0a73d852" to nibble vector (LSB first)
hex_to_nibbles <- function(hexstr) {
  hexstr <- gsub("^0x", "", tolower(hexstr))
  stopifnot(nchar(hexstr) == 16)
  chars <- strsplit(hexstr, "")[[1]]
  lookup <- c(as.character(0:9), letters[1:6])
  to_val <- function(ch) match(ch, lookup) - 1L
  nibs_msbf <- vapply(chars, to_val, integer(1))
  rev(nibs_msbf)
}


# Compare two nibble vectors for equality
nibbles_equal <- function(a, b) {
  if (is.null(a) || is.null(b)) return(FALSE)
  length(a) == length(b) && all(a == b)
}

# Extract nibble value at bit-offset gg (multiple of 4)
# LSB-first indexing: position = gg/4, R index = pos+1
get_nibble_at <- function(nibs, gg) {
  pos <- as.integer(gg / 4L)
  nibs[pos + 1L]
}

# Move nibble at position pos by delta positions (delta can be +/-1, +/-4)
# Clears original pos (sets to 0), and adds the nibble to new position.
move_nibble <- function(nibs, pos, delta) {
  src <- pos
  dst <- pos + delta
  if (dst < 0L || dst > 15L) stop("Nibble move out of bounds")
  v <- nibs[src + 1L]
  if (v == 0L) return(nibs)  # nothing to move
  nibs[src + 1L] <- 0L
  nibs[dst + 1L] <- nibs[dst + 1L] + v  # original code “-a + (a << …)” effectively relocates the nibble
  nibs
}

# (a >> gg) when a is a single-nibble mask at gg just yields that nibble value.
# In our model we already read that nibble directly.

## ----- Target and initial states (as nibbles) -----
# Goal: 0x123456789abcdef0  => nibbles MSB→LSB: 1 2 3 4 5 6 7 8 9 a b c d e f 0
GOAL <- hex_to_nibbles("123456789abcdef0")

# Initial: 0xfe169b4c0a73d852 => nibbles MSB→LSB: f e 1 6 9 b 4 c 0 a 7 3 d 8 5 2
INIT <- hex_to_nibbles("fe169b4c0a73d852")

## ----- Core functions (translated) -----
fY <- function(n) {
  if (nibbles_equal(N2[[n + 1L]], GOAL)) {
    return(list(ans = TRUE, n = n))
  }
  if (N4[n + 1L] <= .n) {
    return(fN(n))
  }
  list(ans = FALSE, n = n)
}

fZ <- function(w, n) {
  if (bitwAnd(w, i) > 0L) {
    n <- fI(n)
    tmp <- fY(n)
    if (tmp$ans) return(tmp)
    n <- n - 1L
  }
  if (bitwAnd(w, g) > 0L) {
    n <- fG(n)
    tmp <- fY(n)
    if (tmp$ans) return(tmp)
    n <- n - 1L
  }
  if (bitwAnd(w, ee) > 0L) {
    n <- fE(n)
    tmp <- fY(n)
    if (tmp$ans) return(tmp)
    n <- n - 1L
  }
  if (bitwAnd(w, l) > 0L) {
    n <- fL(n)
    tmp <- fY(n)
    if (tmp$ans) return(tmp)
    n <- n - 1L
  }
  list(ans = FALSE, n = n)
}

fN <- function(n) {
  x <- N0[n + 1L]
  y <- N3[n + 1L]  # "d","u","r","l"
  if (x == 0L) {
    if (y == "l")      return(fZ(i, n))
    else if (y == "u") return(fZ(ee, n))
    else               return(fZ(i + ee, n))
  } else if (x == 3L) {
    if (y == "r")      return(fZ(i, n))
    else if (y == "u") return(fZ(l, n))
    else               return(fZ(i + l, n))
  } else if (x == 1L || x == 2L) {
    if      (y == "l") return(fZ(i + l, n))
    else if (y == "r") return(fZ(i + ee, n))
    else if (y == "u") return(fZ(ee + l, n))
    else               return(fZ(l + ee + i, n))
  } else if (x == 12L) {
    if      (y == "l") return(fZ(g, n))
    else if (y == "d") return(fZ(ee, n))
    else               return(fZ(ee + g, n))
  } else if (x == 15L) {
    if      (y == "r") return(fZ(g, n))
    else if (y == "d") return(fZ(l, n))
    else               return(fZ(g + l, n))
  } else if (x == 13L || x == 14L) {
    if      (y == "l") return(fZ(g + l, n))
    else if (y == "r") return(fZ(ee + g, n))
    else if (y == "d") return(fZ(ee + l, n))
    else               return(fZ(g + ee + l, n))
  } else if (x == 4L || x == 8L) {
    if      (y == "l") return(fZ(i + g, n))
    else if (y == "u") return(fZ(g + ee, n))
    else if (y == "d") return(fZ(i + ee, n))
    else               return(fZ(i + g + ee, n))
  } else if (x == 7L || x == 11L) {
    if      (y == "d") return(fZ(i + l, n))
    else if (y == "u") return(fZ(g + l, n))
    else if (y == "r") return(fZ(i + g, n))
    else               return(fZ(i + g + l, n))
  } else {
    if      (y == "d") return(fZ(i + ee + l, n))
    else if (y == "l") return(fZ(i + g + l, n))
    else if (y == "r") return(fZ(i + g + ee, n))
    else if (y == "u") return(fZ(g + ee + l, n))
    else               return(fZ(i + g + ee + l, n))
  }
}

# Down: take nibble at gg=(11-N0)*4 and move it left by 16 bits => +4 nibbles
fI <- function(n) {
  gg  <- (11L - N0[n + 1L]) * 4L
  pos <- as.integer(gg / 4L)
  a   <- get_nibble_at(N2[[n + 1L]], gg)
  N0[n + 2L] <<- N0[n + 1L] + 4L
  N2[[n + 2L]] <<- move_nibble(N2[[n + 1L]], pos, +4L)
  N3[n + 2L] <<- "d"
  N4[n + 2L] <<- N4[n + 1L]
  cond <- Nr[a + 1L] <= (N0[n + 1L] %/% 4L)
  if (!cond) N4[n + 2L] <<- N4[n + 2L] + 1L
  n + 1L
}

# Up: gg=(19-N0)*4, move right by 16 bits => -4 nibbles
fG <- function(n) {
  gg  <- (19L - N0[n + 1L]) * 4L
  pos <- as.integer(gg / 4L)
  a   <- get_nibble_at(N2[[n + 1L]], gg)
  N0[n + 2L] <<- N0[n + 1L] - 4L
  N2[[n + 2L]] <<- move_nibble(N2[[n + 1L]], pos, -4L)
  N3[n + 2L] <<- "u"
  N4[n + 2L] <<- N4[n + 1L]
  cond <- Nr[a + 1L] >= (N0[n + 1L] %/% 4L)
  if (!cond) N4[n + 2L] <<- N4[n + 2L] + 1L
  n + 1L
}

# Right: gg=(14-N0)*4, shift by +4 bits => +1 nibble
fE <- function(n) {
  gg  <- (14L - N0[n + 1L]) * 4L
  pos <- as.integer(gg / 4L)
  a   <- get_nibble_at(N2[[n + 1L]], gg)
  N0[n + 2L] <<- N0[n + 1L] + 1L
  N2[[n + 2L]] <<- move_nibble(N2[[n + 1L]], pos, +1L)
  N3[n + 2L] <<- "r"
  N4[n + 2L] <<- N4[n + 1L]
  cond <- Nc[a + 1L] <= (N0[n + 1L] %% 4L)
  if (!cond) N4[n + 2L] <<- N4[n + 2L] + 1L
  n + 1L
}

# Left: gg=(16-N0)*4, shift by -4 bits => -1 nibble
fL <- function(n) {
  gg  <- (16L - N0[n + 1L]) * 4L
  pos <- as.integer(gg / 4L)
  a   <- get_nibble_at(N2[[n + 1L]], gg)
  N0[n + 2L] <<- N0[n + 1L] - 1L
  N2[[n + 2L]] <<- move_nibble(N2[[n + 1L]], pos, -1L)
  N3[n + 2L] <<- "l"
  N4[n + 2L] <<- N4[n + 1L]
  cond <- Nc[a + 1L] >= (N0[n + 1L] %% 4L)
  if (!cond) N4[n + 2L] <<- N4[n + 2L] + 1L
  n + 1L
}

solve_fn <- function(n) {
  tmp <- fN(n)
  ans <- tmp$ans
  n   <- tmp$n
  if (ans) {
    cat(sprintf("Solution found in %d moves:\n", n))
    if (n >= 1L) {
      cat(paste0(N3[2:(n + 1L)], collapse = ""), "\n")
    } else {
      cat("\n")
    }
  } else {
    cat(sprintf("next iteration, .n will be %d...\n", .n + 1L))
    n  <<- 0L
    .n <<- .n + 1L
    solve_fn(n)
  }
}

run <- function() {
  N0[1L] <<- 8L
  .n      <<- 1L
  N2[[1L]] <<- INIT
  # carry forward initial defaults
  N3[1L]  <<- ""
  N4[1L]  <<- 0L
  solve_fn(0L)
}

# Execute
run()
