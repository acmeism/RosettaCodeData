phrase <- "rosetta code phrase reversal"

vstrsplit <- function(s, delim="") unlist(strsplit(s, delim))
strrev <- function(s) paste0(rev(vstrsplit(s)), collapse="")
strrev(phrase)
phraselist <- vstrsplit(phrase, " ")
paste0(sapply(phraselist, strrev), collapse=" ")
paste0(rev(phraselist), collapse=" ")
