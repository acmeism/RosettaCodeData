letterFreq <- function(filename, lettersOnly)
{
  txt <- read.delim(filename, header = FALSE, stringsAsFactors = FALSE, allowEscapes = FALSE, quote = "")
  count <- table(strsplit(paste0(txt[,], collapse = ""), ""))
  if(lettersOnly) count[names(count) %in% c(LETTERS, letters)] else count
}
