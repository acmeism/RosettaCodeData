maxdiffs <- function(v) {
  diffs <- abs(diff(v))
  mdiff <- max(diffs)
  inds <- which(diffs==mdiff)
  paste0(v[inds], ",", v[inds+1], " ==> ", mdiff) |> writeLines()
}

maxdiffs(c(1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8, 6, 2, 9, 11, 10, 3))
