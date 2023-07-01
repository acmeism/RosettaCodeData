strip_comments <- function(str)
{
  if(!require(stringr)) stop("you need to install the stringr package")
  str_trim(str_split_fixed(str, "#|;", 2)[, 1])
}
