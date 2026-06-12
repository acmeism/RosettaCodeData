conjugate_verb <- function(verb){
  vl <- nchar(verb)
  if(vl<4){
    cat("\nCan't conjugate", verb, "(not enough letters)\n")
    return(FALSE)
  }
  suffix <- substring(verb, vl-2)
  declensions <- switch(suffix,
                        "are" = c("o", "as", "at", "amus", "atis", "ant"),
                        "ere" = c("o", "is", "it", "imus", "itis", "unt"),
                        "ēre" = c("eo", "es", "et", "emus", "etis", "ent"),
                        "ire" = c("io", "is", "it", "imus", "itis", "iunt"))
  if(is.null(declensions)){
    cat("\nCan't conjugate", verb, "(not a regular ending)\n")
    return(FALSE)
  }
  replace_suffix <- function(s) sub(paste0(suffix, "$"), s, verb)
  cat("\nConjugation of", verb, "\n")
  writeLines(sapply(declensions, replace_suffix))
  return(TRUE)
}

test_verbs <- c("amare", "venire", "monēre", "tegere", "are", "qwerty")
tests <- sapply(test_verbs, conjugate_verb)
