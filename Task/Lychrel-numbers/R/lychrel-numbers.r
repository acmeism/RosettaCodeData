library(gmp)
library(magrittr)

cache <- NULL

cache_reset <- function() { cache <<- new.env(TRUE, emptyenv()) }
cache_set <- function(key, value) { assign(key, value, envir = cache) }
cache_get <- function(key) { get(key, envir = cache, inherits = FALSE) }
cache_has_key <- function(key) { exists(key, envir = cache, inherits = FALSE) }

# Initialize the cache
cache_reset()

isPalindromic <- function(num) {
  paste0(unlist(strsplit(num,"")), collapse = "") ==
  paste0(rev(unlist(strsplit(num,""))),collapse = "")
}


aStep <- function(num) {
  num %>%
    strsplit("") %>%
    unlist() %>%
    rev() %>%
    paste0(collapse = "") %>%
    sub("^0+","",.) %>%
    as.bigz() %>%
    '+'(num) %>%
    as.character
}

max_search <- 10000
limit <- 500
related <- 0
lychrel <- vector("numeric")
palindrome_lychrel <- vector("numeric")

for (candidate in 1:max_search) {
  n <- as.character(candidate)
  found <- TRUE
  for (iteration in 1:limit) {
    n <- aStep(n)
    if (cache_has_key(n)) {
      related <- related + 1
      found <- FALSE
      if (isPalindromic(as.character(candidate))) palindrome_lychrel <- append(palindrome_lychrel, candidate)
      break
    }
    if (isPalindromic(n)) {
      found <- FALSE
      break
    }
  }
  if (found) {
    if (isPalindromic(as.character(candidate))) palindrome_lychrel <- append(palindrome_lychrel, candidate)
    lychrel <- append(lychrel,candidate)
    seeds <- seeds + 1
    n <- as.character(candidate)
    for (iteration in 1:limit) {
      cache_set(n,"seen")
      n <- aStep(n)
    }
  }
}
cat("Lychrel numbers in the range [1, ",max_search,"]\n", sep = "")
cat("Maximum iterations =",limit,"\n")
cat("Number of Lychrel seeds:",length(lychrel),"\n")
cat("Lychrel numbers:",lychrel,"\n")
cat("Number of related Lychrel numbers found:",related,"\n")
cat("Number of palindromic Lychrel numbers:",length(palindrome_lychrel),"\n")
cat("Palindromic Lychrel numbers:",palindrome_lychrel,"\n")
