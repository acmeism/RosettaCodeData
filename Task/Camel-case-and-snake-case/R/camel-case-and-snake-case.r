test_strings <- c(
  "snakeCase", "snake_case", "variable_10_case",
  "variable10Case", "ɛrgo rE tHis", "hurry-up-joe!",
  "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "
)

titles <- c(
  "Snake to camel case:", "Camel to snake case:",
  "Any separator to camel case:", "Any separator to snake case:"
)

#Simple functions
snake2camel <- function(s) {
  boundaries <- gregexpr("_+[^_]", s) |>
    regmatches(s, m = _) |>
    unlist() |>
    gsub("_", "", x = _)
  for (b in boundaries) {
    s <- gsub(paste0("_+", b), toupper(b), s)
  }
  return(s)
}

camel2snake <- function(s) {
  boundaries <- gregexpr("[A-Z]", s) |>
    regmatches(s, m = _) |>
    unlist()
  for (b in boundaries) {
    s <- gsub(b, paste0("_", tolower(b)), s)
  }
  return(s)
}

#More general functions
any2camel <- function(s) {
  #strip leading and trailing whitespace
  s <- trimws(s)
  #Deal with specified separators
  boundaries <- gregexpr("[ _-]+[^ _-]", s) |>
    regmatches(s, m = _) |>
    unlist() |>
    gsub("[ _-]", "", x = _)
  for (b in boundaries) {
    s <- gsub(paste0("[ _-]+", b), toupper(b), s)
  }
  return(s)
}

any2snake <- function(s) {
  s <- trimws(s)
  boundaries <- function(regexp) {
    gregexpr(regexp, s) |>
    regmatches(s, m = _) |>
    unlist()
  }
  for (b in boundaries("[A-Z]")) {
    s <- gsub(b, paste0("_", tolower(b)), s)
  }
  for (b in boundaries("[ -]+")) {
    s <- gsub(b, "_", s)
  }
  return(s)
}

funs <- c(snake2camel, camel2snake, any2camel, any2snake)
for (i in 1:4) {
  writeLines(c(titles[i], funs[[i]](test_strings), ""))
}
