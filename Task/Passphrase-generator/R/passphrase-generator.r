#Helper functions
minchars <- function(n) function(s) nchar(s) >= n
lettersonly <- function(s) !grepl("[^A-Za-z]", s)
totitle <- function(s) paste0(toupper(substring(s, 1, 1)), substring(s, 2))

#From unixdict, filter out short words and words with non-letter characters
unixwords <- readLines("unixdict.txt") |>
  Filter(lettersonly, x = _) |>
  Filter(minchars(4), x = _)

#After this, actually constructing the passphrase is very simple
passphrase <- function(n) {
  words <- sample(unixwords, n) |> totitle()
  numbers <- sample(10:99, n)
  paste0(words, numbers, collapse = "-")
}

passphrase(5)
