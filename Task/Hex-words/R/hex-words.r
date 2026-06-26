library(stringr)

#Method 1 for calculating digital root: casting to a string (slower, but accurate)
dig_root <- function(n) {
  options(scipen = 99)
  while (n > 9) {
    n <- as.character(n) |> str_split_1("") |> as.numeric() |> sum()
  }
  return(n)
}

#Method 2: using modulus operators recursively (can be inaccurate for very large n)
dig_root <- function(n) ifelse(n > 9, dig_root(n%%10 + dig_root(n%/%10)), n)

#Method 3: using a mathematical formula (probably the fastest way)
dig_root <- function(n) ifelse(n == 0, 0, 1+(n-1)%%9)

hexwords <- read.table("unixdict.txt", col.names = "words") |>
  subset(str_detect(words, "^[a-f]{4,}$")) |>
  transform(decimal = strtoi(words, 16L)) |>
  transform(root = sapply(decimal, dig_root)) |>
  sort_by(~root) |>
  `rownames<-`(NULL) |>
  print()

#The second part is impossible to do with a single regex AFAIK
#So check strings by counting instances of each letter
counts_logical <- function(s) {
  counts <- sapply(letters[1:6], function(char) str_count(s, char))
  sum(counts > 0)
}

has4distinct <- sapply(hexwords$words, counts_logical) > 3

subset(hexwords, has4distinct) |>
  sort_by(~I(-decimal)) |>
  `rownames<-`(NULL)
