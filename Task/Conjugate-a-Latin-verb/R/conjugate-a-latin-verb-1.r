conjugate_verb <- function(verb) {
  verb_length <- nchar(verb)
  suffix_start <- verb_length - 2
  root_end <- verb_length - 3
  verb_ending <- substr(verb, suffix_start, verb_length)
  verb_root <- substr(verb, 1, root_end)
  verb_endings <- switch(verb_ending,
                         "are" = c("o", "as", "at", "amus", "atis", "ant"),
                         "ere" = c("o", "is", "it", "imus", "itis", "unt"),
                         "ēre" = c("eo", "es", "et", "emus", "etis", "ent"),
                         "ire" = c("io", "is", "it", "imus", "itis", "iunt"))
  cat("\n")
  cat(paste0("Conjugation of ", verb, "\n"))
  for(i in verb_endings) {
    cat(paste0(verb_root, i, "\n"))
  }
}

for (i in c("amare", "venire", "monēre", "tegere")) {
  conjugate_verb(i)
}
