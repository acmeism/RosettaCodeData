library(stringr)

stripchars <- function(s, chars) {
  charv <- str_split_1(chars, "")
  named <- setNames(rep("", length(charv)), charv)
  str_replace_all(s, fixed(named))
}

stripchars("She was a soul stripper. She took my heart!", "aei")
#Regex is not used, so none of these characters cause trouble
stripchars("Bet you can't do this one! -\\^.*?(|)[{}]+$", "-\\^.*?(|)[{}]+$")
