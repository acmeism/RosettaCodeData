library(stringr)

num_vc <- function(s) {
  s <- str_to_lower(s) |> str_extract_all("[a-z]", simplify = TRUE)
  num_vowels <- str_count(s, "[aeiou]") |> sum()
  num_consonants <- str_count(s, "[^aeiou]") |> sum()
  cat("Vowel count is", num_vowels,
      "| Consonant count is", num_consonants, "\n")
}

num_vc("We must know! We will know!")
