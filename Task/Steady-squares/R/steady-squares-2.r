Filter(function(n) endsWith(as.character(n^2), as.character(n)), 1:10000) |>
  (function(v) paste0(v, "^2 = ", v^2))() |>
  writeLines()
