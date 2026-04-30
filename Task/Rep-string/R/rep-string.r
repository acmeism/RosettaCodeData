is_repeated <- function(s) {
  for (i in 1+(nchar(s) %/% 2):0) {
    if (startsWith(s, substring(s, i))) {
      return(i-1)
    }
  }
}

test_strings <- c("1001110011",
                  "1110111011",
                  "0010010010",
                  "1010101010",
                  "1111111111",
                  "0100101101",
                  "0100100",
                  "101",
                  "11",
                  "00",
                  "1")

result <- sapply(test_strings, is_repeated)
repeaters <- substring(test_strings, 1, result)
repeaters <- ifelse(repeaters != "", repeaters, "[none]")
writeLines(paste(test_strings,
                 "has a repetition length of",
                 result,
                 "with repeating unit",
                 repeaters))
