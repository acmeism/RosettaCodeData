lempelziv <- function(s) {
  phrases <- c()
  n <- nchar(s)
  if (n == 0) return(phrases)
  i <- 0
  while (i < n) {
    k <- 1
    while (i + k <= n && grepl(substring(s, i+1, i+k),
                               substring(s, 1, i+k-1),
                               fixed = TRUE)) {
      k <- k+1
    }
    phrase <- ifelse(i+k <= n, substring(s, i+1, i+k), substring(s, i+1, n))
    phrases <- c(phrases, phrase)
    i <- i + nchar(phrase)
  }
  return(phrases)
}

tests <- c(
  "AZSEDRFTGYGUJIJOKB",
  "ABCABCABCABCABCABC",
  "111011111001111011111001",
  "101001010010111110",
  "1001111011000010",
  "1010101010",
  "1010101010101010",
  "1001111011000010000010",
  "100111101100001000001010",
  "0001101001000101",
  "1111111",
  "0001",
  "010",
  "1",
  "",
  "01011010001101110010",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!"
)

for (test in tests) {
  lz <- lempelziv(test)
  cat(test, "has L-Z complexity:", length(lz), "\n")
  cat("Substrings are",
      ifelse(length(lz) == 0,
             "None",
             paste0(lz, collapse = "|")),
      "\n")
}
