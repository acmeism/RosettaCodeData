namegame <- function(name) {
  bfm <- function(char) ifelse(startsWith(name, char), "", tolower(char))
  #Y is only considered a starting vowel if it is followed by a consonant
  name_trunc <- ifelse(
    grepl("^[AEIOU]|^Y[^aeiou]", name),
    tolower(name),
    substring(name, 2)
  )
  paste0(
    name, ", ", name, ", ", "bo-", bfm("B"), name_trunc,
    "\nBanana-fana fo-", bfm("F"), name_trunc,
    "\nFee-fi-mo-", bfm("M"), name_trunc,
    "\n", name, "!"
  )
}

test_names <- c("Gary", "Earl", "Billy", "Felix", "Mary", "Yancy", "Yvonne")
cat(sapply(test_names, namegame), sep = "\n\n")
