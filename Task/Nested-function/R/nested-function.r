MakeList <- function(sep)
{
  counter <- 0
  MakeItem <- function() paste0(counter <<- counter + 1, sep, c("first", "second", "third")[counter])
  cat(replicate(3, MakeItem()), sep = "\n")
}
MakeList(". ")
