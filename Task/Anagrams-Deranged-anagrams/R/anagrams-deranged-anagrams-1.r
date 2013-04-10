puzzlers.dict <- readLines("http://www.puzzlers.org/pub/wordlists/unixdict.txt")

longest.deranged.anagram <- function(dict=puzzlers.dict) {
  anagram.groups <- function(word.group) {
    sorted <- sapply(lapply(strsplit(word.group,""),sort),paste, collapse="")
    grouped <- tapply(word.group, sorted, force, simplify=FALSE)
    grouped <- grouped[sapply(grouped, length) > 1]
    grouped[order(-nchar(names(grouped)))]
  }

  derangements <- function(anagram.group) {
    pairs <- expand.grid(a = anagram.group, b = anagram.group,
                         stringsAsFactors=FALSE)
    pairs <- subset(pairs, a < b)
    deranged <- with(pairs, mapply(function(a,b) all(a!=b),
                                   strsplit(a,""), strsplit(b,"")))
    pairs[which(deranged),]
  }

  for (anagram.group in anagram.groups(dict)) {
    if (nrow(d <- derangements(anagram.group)) > 0) {
      return(d[1,])
    }
  }
}
