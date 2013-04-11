rot13 <- function(x)
{
  old <- paste(letters, LETTERS, collapse="", sep="")
  new <- paste(substr(old, 27, 52), substr(old, 1, 26), sep="")
  chartr(old, new, x)
}
x <- "The Quick Brown Fox Jumps Over The Lazy Dog!.,:;'#~[]{}"
rot13(x)   # "Gur Dhvpx Oebja Sbk Whzcf Bire Gur Ynml Qbt!.,:;'#~[]{}"
x2 <- paste(letters, LETTERS, collapse="", sep="")
rot13(x2)  # "nNoOpPqQrRsStTuUvVwWxXyYzZaAbBcCdDeEfFgGhHiIjJkKlLmM"
