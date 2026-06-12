unixdict <- read.table("unixdict.txt", col.names = "words")
#Remove all words with length less than 6
words_6plus <- subset(unixdict, nchar(words) > 5)
splitwords <- strsplit(words_6plus$words, "")

alternate_chars <- function(n) function(v) {
  paste0(v[seq(n, length(v), 2)], collapse = "")
}
words_6plus$odds <- sapply(splitwords, alternate_chars(1))
words_6plus$evens <- sapply(splitwords, alternate_chars(2))

alternades <- words_6plus |>
  subset(odds %in% unixdict$words & evens %in% unixdict$words) |>
  `rownames<-`(NULL) |>
  print()
