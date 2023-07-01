is.Palindrome <- function(string)
{
  characters <- unlist(strsplit(string, ""))
  all(characters == rev(characters))
}
