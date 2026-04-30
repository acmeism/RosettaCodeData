options(scipen=999)  # prevent scientific notation

multiplicationtable <- matrix(c(
  0,1,2,3,4,5,6,7,8,9,
  1,2,3,4,0,6,7,8,9,5,
  2,3,4,0,1,7,8,9,5,6,
  3,4,0,1,2,8,9,5,6,7,
  4,0,1,2,3,9,5,6,7,8,
  5,9,8,7,6,0,4,3,2,1,
  6,5,9,8,7,1,0,4,3,2,
  7,6,5,9,8,2,1,0,4,3,
  8,7,6,5,9,3,2,1,0,4,
  9,8,7,6,5,4,3,2,1,0
), nrow=10, byrow=TRUE)

permutationtable <- matrix(c(
  0,1,2,3,4,5,6,7,8,9,
  1,5,7,6,2,8,3,0,9,4,
  5,8,0,3,7,9,6,1,4,2,
  8,9,1,6,0,4,3,5,2,7,
  9,4,5,3,1,2,6,8,7,0,
  4,2,8,6,5,7,3,9,0,1,
  2,7,9,3,8,0,6,4,1,5,
  7,0,4,6,9,1,3,2,5,8
), nrow=8, byrow=TRUE)

inv <- c(0,4,3,2,1,5,6,7,8,9)

verhoeffchecksum <- function(n, validate=TRUE, terse=TRUE, verbose=FALSE) {
  nstr <- as.character(n)  # keep number as string
  if (verbose) {
    cat("\n", ifelse(validate, "Validation", "Check digit"),
        " calculations for '", nstr, "':\n\n",
        " i  nᵢ  p[i,nᵢ]  c\n------------------\n", sep="")
  }

  dig <- as.integer(strsplit(if (validate) nstr else paste0(nstr, "0"), "")[[1]])
  dig <- rev(dig)   # Julia uses reverse

  c <- 0
  for (i in seq_along(dig)) {
    ni <- dig[i]
    p <- permutationtable[(i - 1) %% 8 + 1, ni + 1]
    c <- multiplicationtable[c + 1, p + 1]
    if (verbose) {
      cat(sprintf("%2d  %d      %d     %d\n", i-1, ni, p, c))
    }
  }

  if (verbose && !validate) {
    cat("\ninv[", c, "] = ", inv[c + 1], "\n", sep="")
  }
  if (!terse) {
    if (validate) {
      cat("\nThe validation for '", nstr, "' is ",
          ifelse(c == 0, "correct", "incorrect"), ".\n", sep="")
    } else {
      cat("\nThe check digit for '", nstr, "' is '", inv[c + 1], "'\n", sep="")
    }
  }

  if (validate) {
    return(c == 0)
  } else {
    return(inv[c + 1])
  }
}

# Test runs
tests <- list(
  list("236", FALSE, FALSE, TRUE),
  list("2363", TRUE, FALSE, TRUE),
  list("2369", TRUE, FALSE, TRUE),
  list("12345", FALSE, FALSE, TRUE),
  list("123451", TRUE, FALSE, TRUE),
  list("123459", TRUE, FALSE, TRUE),
  list("123456789012", FALSE, FALSE),
  list("1234567890120", TRUE, FALSE),
  list("1234567890129", TRUE, FALSE)
)

for (args in tests) {
  do.call(verhoeffchecksum, args)
}
