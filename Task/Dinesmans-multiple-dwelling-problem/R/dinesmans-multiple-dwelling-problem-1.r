names = unlist(strsplit("baker cooper fletcher miller smith", " "))

test <- function(floors) {
  f <- function(name) which(name == floors)
  if ((f('baker') != 5) &&
      (f('cooper') != 1) &&
      (any(f('fletcher') == 2:4)) &&
      (f('miller') > f('cooper')) &&
      (abs(f('fletcher') - f('cooper')) > 1) &&
      (abs(f('smith') - f('fletcher')) > 1))
    cat("\nFrom bottom to top: --> ", floors, "\n")
}

do.perms <- function(seq, func, built = c()){
  if (0 == length(seq))  func(built)
  else  for (x in seq) do.perms( seq[!seq==x], func, c(x, built)) }
