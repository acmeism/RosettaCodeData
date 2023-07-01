quib <- function(vect)
{
  #The task does not consider empty strings to be words, so we remove them immediately.
  #We could also remove non-upper-case characters, but the tasks gives off the impression that the user will do that.
  vect <- vect[nchar(vect) != 0]
  len <- length(vect)
  allButLastWord <- if(len >= 2) paste0(vect[seq_len(len - 1)], collapse = ", ") else ""
  paste0("{", if(nchar(allButLastWord) == 0) vect else paste0(allButLastWord, " and ", vect[len]), "}")
}
quib(character(0)) #R has several types of empty string, e.g. character(0), "", and c("", "", "").
quib("")
quib(" ")
quib(c("", ""))
quib(rep("", 10))
quib("ABC")
quib(c("ABC", ""))
quib(c("ABC", "DEF"))
quib(c("ABC", "DEF", "G", "H"))
quib(c("ABC", "DEF", "G", "H", "I", "J", ""))
