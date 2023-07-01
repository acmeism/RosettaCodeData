checkSentence <- function(sentence){
# Input: character vector
# Output: whether the sentence formed by the elements of the vector is valid
  for (index in 1:(length(sentence)-1)){
    first.word  <- sentence[index]
    second.word <- sentence[index+1]

    last.letter  <- substr(first.word, nchar(first.word), nchar(first.word))
    first.letter <- substr(second.word, 1, 1)

    if (last.letter != first.letter){ return(FALSE) }
  }
  return(TRUE)
}

amb <- function(sets){
# Input: list of character vectors containing all sets to consider
# Output: list of character vectors that are valid
  all.paths      <- apply(expand.grid(sets), 2, as.character)
  all.paths.list <- split(all.paths, 1:nrow(all.paths))
  winners        <- all.paths.list[sapply(all.paths.list, checkSentence)]
  return(winners)
}
