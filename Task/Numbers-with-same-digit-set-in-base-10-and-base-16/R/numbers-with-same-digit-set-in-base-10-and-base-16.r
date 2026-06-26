charset <- function(x) {
  as.character(x) |>
    strsplit("") |>
    unlist() |>
    unique() |>
    sort()
}

cat(Filter(function(n) identical(charset(n), charset(as.hexmode(n))), 0:100000))
