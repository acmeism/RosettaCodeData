## BalancedTernary in R (S3)

## Constructor helpers ----
new_BalancedTernary <- function(digits) {
  # digits are least-significant first, values in {-1,0,1}
  structure(list(digits = as.integer(digits)), class = "BalancedTernary")
}

BalancedTernary <- function(x = 0L) {
  if (inherits(x, "BalancedTernary")) return(x)
  if (is.character(x)) return(BalancedTernary_from_string(x))
  if (length(x) != 1 || !is.finite(x)) stop("BalancedTernary: need a single finite number or a string.")
  BalancedTernary_from_int(as.integer(x))
}

BalancedTernary_zero <- function() new_BalancedTernary(0L)

## Conversions ----
BalancedTernary_from_int <- function(n) {
  n <- as.integer(n)
  if (n == 0L) return(new_BalancedTernary(0L))
  digs <- integer(0)
  while (n != 0L) {
    r <- n %% 3L
    if (r == 0L) {
      digs <- c(digs, 0L); n <- n %/% 3L
    } else if (r == 1L) {
      digs <- c(digs, 1L); n <- n %/% 3L
    } else { # r == 2  -> digit -1 and carry +1 (i.e., add 1 then divide)
      digs <- c(digs, -1L); n <- (n + 1L) %/% 3L
    }
  }
  new_BalancedTernary(digs)
}

BalancedTernary_from_string <- function(s) {
  # string is most-significant first with '-', '0', '+'
  map <- c("-" = -1L, "0" = 0L, "+" = 1L)
  chs <- strsplit(s, "", fixed = TRUE)[[1]]
  if (!all(chs %in% names(map))) stop("String may only contain '-', '0', '+'.")
  # reverse to least-significant first
  new_BalancedTernary(unname(map[rev(chs)]))
}

bt <- function(s) BalancedTernary_from_string(s)  # macro-ish convenience

## Printing & coercion ----
print.BalancedTernary <- function(x, ...) {
  cat(as.character(x), "\n", sep = "")
  invisible(x)
}

as.character.BalancedTernary <- function(x, ...) {
  map <- c(`-1` = "-", `0` = "0", `1` = "+")
  # display most-significant first
  paste0(rev(map[as.character(x$digits)]), collapse = "")
}

as.integer.BalancedTernary <- function(x, ...) {
  s <- x$digits
  if (length(s) == 1L && s[1] == 0L) return(0L)
  ex <- seq_along(s) - 1L
  # use double accumulate then coerce to integer (safe for moderate sizes)
  val <- sum((3 ^ ex) * s)
  as.integer(val)
}

## Unary minus ----
`-.BalancedTernary` <- function(e1) new_BalancedTernary(-e1$digits)

## Core arithmetic helpers ----
# Addition table for (a1 + b1 + c) -> (digit, carry),
# indexed by 4 + a1 + b1 + c where a1,b1,c in {-1,0,1} gives 1..7
.bt_table_digit <- c( 0,  1, -1, 0, 1, -1, 0)  # d
.bt_table_carry <- c(-1, -1,  0, 0, 0,  1, 1)  # c

.bt_add <- function(a, b, c = 0L) {
  # a,b are integer vectors of digits (LSB first) in {-1,0,1}
  if (length(a) == 0L || length(b) == 0L) {
    if (c == 0L) return(if (length(a) == 0L) b else a)
    return(.bt_add(c(c), if (length(a) == 0L) b else a))
  } else {
    a1 <- a[1]; b1 <- b[1]
    idx <- 4L + a1 + b1 + c
    d <- .bt_table_digit[idx]
    c2 <- .bt_table_carry[idx]
    r <- .bt_add(a[-1], b[-1], c2)
    if (length(r) != 0L || d != 0L) {
      return(c(d, r))  # unshift
    } else {
      return(r)
    }
  }
}

.bt_mul <- function(a, b) {
  # schoolbook recursion with balanced digits
  if (length(a) == 0L || length(b) == 0L) return(integer(0))
  a1 <- a[1]
  if (a1 == -1L) x <- (-BalancedTernary(new_BalancedTernary(b)))$digits
  else if (a1 == 0L) x <- integer(0)
  else if (a1 == 1L) x <- b
  # shift (multiply by 3) = prepend a 0 digit to recursive product
  y <- c(0L, .bt_mul(a[-1], b))
  .bt_add(x, y)
}

.normalize_zero <- function(v) if (length(v) == 0L) 0L else v

## Binary operators ----
`+.BalancedTernary` <- function(e1, e2) {
  v <- .bt_add(e1$digits, e2$digits)
  new_BalancedTernary(.normalize_zero(v))
}

`-.BalancedTernary`  # already defined (unary)

`%minus_bt%` <- function(a, b) a + (-b)  # internal helper if needed

`*.BalancedTernary` <- function(e1, e2) {
  v <- .bt_mul(e1$digits, e2$digits)
  new_BalancedTernary(.normalize_zero(v))
}

## Demo / tests ----
a <- bt("+-0++0+")
cat("a: ", as.integer(a), ", ", as.character(a), "\n", sep = "")

b <- BalancedTernary(-436L)
cat("b: ", as.integer(b), ", ", as.character(b), "\n", sep = "")

c <- BalancedTernary("+-++-")
cat("c: ", as.integer(c), ", ", as.character(c), "\n", sep = "")

r <- a * (b + (-c))  # a * (b - c)
cat("a * (b - c): ", as.integer(r), ", ", as.character(r), "\n", sep = "")

stopifnot(as.integer(r) == as.integer(a) * (as.integer(b) - as.integer(c)))
