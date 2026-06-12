words <- readLines("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
grep("the", words[nchar(words) > 11], value = T)
