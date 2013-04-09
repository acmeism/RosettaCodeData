balanced <- function(str) {
  regexpr('^(\\[(?1)*\\])*$', str, perl=TRUE) > -1
}
