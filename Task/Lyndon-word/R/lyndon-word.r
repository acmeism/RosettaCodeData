library(stringr)

next_lyndon <- function(n, w, alphabet) {
  last <- tail(alphabet, 1)
  x <- str_dup(w, 1 + n %/% nchar(w)) |> str_sub(end = n)
  while (str_ends(x, last)) {
    x <- str_sub(x, end = -2)
  }
  xend <- str_sub(x, start = -1)
  if (xend %in% alphabet) {
    successor <- alphabet[1 + which(alphabet == xend)]
     x <- str_replace(x, str_glue("{xend}$"), successor)
  }
  return(x)
}

all_lyndons <- function(n, alphabet) {
  w <- alphabet[1]
  last <- tail(alphabet, 1)
  repeat {
    cat(w, "")
    if (w == last) break
    w <- next_lyndon(n, w, alphabet)
  }
}

all_lyndons(5, c("0", "1"))
