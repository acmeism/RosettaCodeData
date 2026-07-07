library(gmp)

vsprintf <- function(fmt, v) do.call(sprintf, c(fmt, as.list(v)))

next_denom <- function(x, y) (y%%x > 0) + y%/%x

greedy_egyptian <- function(a, b) {
  x <- as.bigz(a)
  y <- as.bigz(b)
  fracs <- NULL
  if (x > y) {
    fracs <- c(x%/%y, fracs)
    x <- x%%y
    if (x == 0) return(fracs)
  }
  fracs <- c(1/next_denom(x, y), fracs)
  while (y%%x > 0) {
    x_new <- -y%%x
    y_new <- y*(1 + y%/%x)
    x <- x_new
    y <- y_new
    fracs <- c(1/next_denom(x, y), fracs)
  }
  rev(fracs)
}

print_fracs <- function(v, head = TRUE) {
  frac <- vsprintf("%i/%i: ", v)
  reprs <- do.call(greedy_egyptian, as.list(v))
  res <- vsprintf(c(strrep("%s ", length(reprs))), reprs)
  paste0(if (head) frac else "", res)
}

test_fracs <- list(c(43, 48), c(5, 121), c(2014, 59))

sapply(test_fracs, print_fracs) |> writeLines()

len_ge <- function(x, y) length(greedy_egyptian(x, y))
last_denom <- function(x, y) 1/tail(greedy_egyptian(x, y), 1)

maxidxs <- function(f, showmax = TRUE, big = FALSE) {
  mat <- outer(2:99, 2:99, Vectorize(f))
  idx <- mat |>
    `dim<-`(NULL) |>
    (function(x) if(big) c_bigq(x) else x)() |>
    which.max()
  idxs <- c(1 + idx %% 98, 2 + idx %/% 98)
  if (showmax) c(idxs, max(mat)) else idxs
}

lmax <- maxidxs(len_ge)
dmax <- maxidxs(last_denom, showmax = FALSE, big = TRUE)

cat(
  "",
  vsprintf("%i/%i has maximum length of %i:", lmax),
  print_fracs(lmax[-3], head = FALSE),
  "",
  vsprintf("%i/%i contains the largest denominator:", dmax),
  print_fracs(dmax, head = FALSE),
  sep = "\n"
)
