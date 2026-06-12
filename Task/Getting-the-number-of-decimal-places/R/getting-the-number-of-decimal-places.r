decimals <- function(){
  d <- readline("Enter a decimal number (trailing zeros allowed): ")
  nchar(regmatches(d, m=regexpr("\\.\\d+$", d)))-1
}

replicate(2, decimals())
