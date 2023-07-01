isAllSame <- function(string)
{
  strLength <- nchar(string)
  if(length(strLength) > 1)
  {
    #R has a distinction between the length of a string and that of a character vector. It is a common source
    #of problems when coming from another language. We will try to avoid the topic here.
    #For our purposes, let us only say that there is a good reason why we have made
    #isAllSame(c("foo", "bar") immediately throw an error.
    stop("This task is intended for character vectors with lengths of at most 1.")
  }
  else if(length(strLength) == 0)
  {
    cat("Examining a character vector of length 0.\n")
    TRUE
  }
  else if(strLength == 0)
  {
    cat("Examining a character vector of length 1, containing an empty string.\n")
    TRUE
  }
  else
  {
    cat("Examining the string", paste0(sQuote(string), ","),
        "which is of length", paste0(strLength, ":"), "\n")
    #strsplit outputs a list. Its first element is the vector of characters that we desire.
    characters <- strsplit(string, "")[[1]]
    #Our use of match is using R's vector recycling rules. Every element is being checked
    #against the first.
    differentElementIndex <- match(FALSE, characters[1] == characters, nomatch = 0)
    if(differentElementIndex == 0)
    {
      cat("It has no duplicates.\n")
      TRUE
    }
    else
    {
      cat("It has duplicates. ")
      firstDifferentCharacter <- characters[differentElementIndex]
      cat(sQuote(firstDifferentCharacter), "is the first different character. It has hex value",
          sprintf("0x%X", as.integer(charToRaw(firstDifferentCharacter))),
          "and is at index", paste0(differentElementIndex, "."), "\n")
      FALSE
    }
  }
}

#Tests:
cat("Test: A string of length 0 (an empty string):\n")
cat("Test 1 of 2: An empty character vector:\n")
print(isAllSame(character(0)))
cat("Test 2 of 2: A character vector containing the empty string:\n")
print(isAllSame(""))
cat("Test: A string of length 3 which contains three blanks:\n")
print(isAllSame("   "))
cat("Test: A string of length 1 which contains 2:\n")
print(isAllSame("2"))
cat("Test: A string of length 3 which contains 333:\n")
print(isAllSame("333"))
cat("Test: A string of length 3 which contains .55:\n")
print(isAllSame(".55"))
cat("Test: A string of length 6 which contains tttTTT:\n")
print(isAllSame("tttTTT"))
cat("Test: A string of length 9 which contains 4444 444k:\n")
print(isAllSame("4444 444k"))
