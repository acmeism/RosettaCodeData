eng2greek <- function(s){
  regexps <- c("\U0391" = "A",
               "\U0392" = "[BV]",
               "\U0393" = "G",
               "\U0394" = "D",
               "\U0395" = "E(?!e)",
               "\U0396" = "Z",
               "\U0397" = "H|Ee",
               "\U0398" = "Th",
               "\U0399" = "[IJ]",
               "\U039A" = "(C|K)(?!h)|Q",
               "\U039B" = "L",
               "\U039C" = "M",
               "\U039D" = "N",
               "\U039E" = "X",
               "\U039F" = "O(?!o)",
               "\U03A0" = "P(?![hs])",
               "\U03A1" = "Rh|R",
               "\U03A3" = "S",
               "\U03A4" = "T(?!h)",
               "\U03A5" = "[UY]",
               "\U03A6" = "F|Ph",
               "\U03A7" = "(C|K)h",
               "\U03A8" = "Ps",
               "\U03A9" = "W|Oo",
               "\U03B1" = "a",
               "\U03B2" = "[bv]",
               "\U03B3" = "g",
               "\U03B4" = "d",
               "\U03B5" = "(?<!e)e(?!e)",
               "\U03B6" = "z",
               "\U03B7" = "(?<![ckprt])h|ee",
               "\U03B8" = "th",
               "\U03B9" = "[ij]",
               "\U03BA" = "(ck|c|k)(?!h)|q",
               "\U03BB" = "l",
               "\U03BC" = "m",
               "\U03BD" = "n",
               "\U03BE" = "x",
               "\U03BF" = "(?<!o)o(?!o)",
               "\U03C0" = "p(?![hs])",
               "\U03C1" = "rh|r",
               "\U03C2" = "(?<!p)s(?=[\\s\\.,:;!?])",
               "\U03C3" = "(?<!p)s",
               "\U03C4" = "t(?!h)",
               "\U03C5" = "[uy]",
               "\U03C6" = "f|ph",
               "\U03C7" = "(c|k)h",
               "\U03C8" = "ps",
               "\U03C9" = "w|oo")

  for(i in seq_along(regexps)){
    s <- gsub(regexps[i], names(regexps)[i], s, perl=TRUE)
  }
  return(s)
}

text1 <- "The quick brown fox jumped over the lazy dog."
text2 <- "sphinx of black quartz, judge my vow."
longtext <- "I was looking at some rhododendrons in my back garden,
dressed in my khaki shorts, when the telephone rang.

As I answered it, I cheerfully glimpsed that the July sun
caused a fragment of black pine wax to ooze on the velvet quilt
laying in my patio."

cat(sapply(c(text1, text2, longtext), eng2greek), sep="\n\n")
