unique_vc <- function(s) {
  s <- str_to_lower(s) |> str_extract_all("[a-z]", simplify = TRUE)
  vowels <- str_subset(s, "[aeiou]") |> unique()
  consonants <- str_subset(s, "[^aeiou]") |> unique()
  cat("Unique vowel count is", length(vowels),
      "| Unique consonant count is", length(consonants), "\n")
}

unique_vc("We must know! We will know!")
