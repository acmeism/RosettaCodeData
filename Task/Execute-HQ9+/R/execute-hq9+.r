bottles <- function() {
  s <- function(n) ifelse(n == 1, "", "s")
  z <- function(n) ifelse(n == 0, "No more", n)
  paste0(
      99:1, " bottle", s(99:1), " of beer on the wall,\n",
      99:1, " bottle", s(99:1), " of beer,\n",
      "Take one down, pass it around,\n",
      z(98:0), " bottle", s(98:0), " of beer on the wall."
  ) |> cat(sep = "\n\n")
}

hq9plus <- function(s) {
  accumulator <- 0
  chars <- toupper(s) |> strsplit("") |> unlist()
  for (char in chars) {
    switch(
      char,
      "H" = cat("Hello World!", "\n"),
      "Q" = cat(s, "\n"),
      "9" = bottles(),
      "+" = accumulator <- accumulator + 1
    )
  }
  cat("The value of the accumulator is", accumulator)
}

hq9plus(readline())
