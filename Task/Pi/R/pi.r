suppressMessages(library(gmp))
ONE <- as.bigz("1")
TWO <- as.bigz("2")
THREE <- as.bigz("3")
FOUR <- as.bigz("4")
SEVEN <- as.bigz("7")
TEN <- as.bigz("10")

q <- as.bigz("1")
r <- as.bigz("0")
t <- as.bigz("1")
k <- as.bigz("1")
n <- as.bigz("3")
l <- as.bigz("3")

char_printed <- 0

how_many <- 1000

first <- TRUE
while (how_many > 0) {
  if ((FOUR * q + r - t) < (n * t)) {
    if (char_printed == 80) {
      cat("\n")
      char_printed <- 0
    }
    how_many <- how_many - 1
    char_printed <- char_printed + 1
    cat(as.integer(n))
    if (first) {
      cat(".")
      first <- FALSE
      char_printed <- char_printed + 1
    }
    nr <- as.bigz(TEN * (r - n * t))
    n <- as.bigz(((TEN * (THREE * q + r)) %/% t) - (TEN * n))
    q <- as.bigz(q * TEN)
    r <- as.bigz(nr)
  } else {
    nr <- as.bigz((TWO * q + r) * l)
    nn <- as.bigz((q * (SEVEN * k + TWO) + r * l) %/% (t * l))
    q <- as.bigz(q * k)
    t <- as.bigz(t * l)
    l <- as.bigz(l + TWO)
    k <- as.bigz(k + ONE)
    n <- as.bigz(nn)
    r <- as.bigz(nr)
  }
}
cat("\n")
