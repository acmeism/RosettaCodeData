isAllUnique <- function(string)
{
  strLength <- nchar(string)
  if(length(strLength) > 1)
  {
    #R has a distinction between the length of a string and that of a character vector. It is a common source
    #of problems when coming from another language. We will try to avoid the topic here.
    #For our purposes, let us only say that there is a good reason why we have made
    #isAllUnique(c("foo", "bar") immediately throw an error.
    stop("This task is intended for character vectors with lengths of at most 1.")
  }
  else if(length(strLength) == 0)
  {
    cat("Examining a character vector of length 0.",
        "It is therefore made entirely of unique characters.\n")
    TRUE
  }
  else if(strLength == 0)
  {
    cat("Examining a character vector of length 1, containing an empty string.",
        "It is therefore made entirely of unique characters.\n")
    TRUE
  }
  else if(strLength == 1)
  {
    cat("Examining the string", paste0(sQuote(string), ","),
        "which is of length", paste0(strLength, "."),
        "It is therefore made entirely of unique characters.\n")
    TRUE
  }
  else
  {
    cat("Examining the string", paste0(sQuote(string), ","),
        "which is of length", paste0(strLength, ":"), "\n")
    #strsplit outputs a list. Its first element is the vector of characters that we desire.
    characters <- strsplit(string, "")[[1]]
    #Our use of match is using R's vector recycling rules. Element i is being checked
    #against every other.
    indexesOfDuplicates <- sapply(seq_len(strLength), function(i) match(TRUE, characters[i] == characters[-i], nomatch = -1)) + 1
    firstDuplicateElementIndex <- indexesOfDuplicates[indexesOfDuplicates != 0][1]
    if(is.na(firstDuplicateElementIndex))
    {
      cat("It has no duplicates. It is therefore made entirely of unique characters.\n")
      TRUE
    }
    else
    {
      cat("It has duplicates. ")
      firstDuplicatedCharacter <- characters[firstDuplicateElementIndex]
      cat(sQuote(firstDuplicatedCharacter), "is the first duplicated character. It has hex value",
          sprintf("0x%X", as.integer(charToRaw(firstDuplicatedCharacter))),
          "and is at index", paste0(firstDuplicateElementIndex, "."),
          "\nThis is a duplicate of the character at index",
          paste0(match(firstDuplicateElementIndex, indexesOfDuplicates), "."), "\n")
      FALSE
    }
  }
}

#Tests:
cat("Test: A string of length 0 (an empty string):\n")
cat("Test 1 of 2: An empty character vector:\n")
print(isAllUnique(character(0)))
cat("Test 2 of 2: A character vector containing the empty string:\n")
print(isAllUnique(""))
cat("Test: A string of length 1 which contains .:\n")
print(isAllUnique("."))
cat("Test: A string of length 6 which contains abcABC:\n")
print(isAllUnique("abcABC"))
cat("Test: A string of length 7 which contains XYZ ZYX:\n")
print(isAllUnique("XYZ ZYX"))
cat("Test: A string of length 36 doesn't contain the letter 'oh':\n")
print(isAllUnique("1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"))
