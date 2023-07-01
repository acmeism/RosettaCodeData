rangeExpand <- function(text) {
  lst <- gsub("(\\d)-", "\\1:", unlist(strsplit(text, ",")))
  unlist(sapply(lst, function (x) eval(parse(text=x))), use.names=FALSE)
}

rangeExpand("-6,-3--1,3-5,7-11,14,15,17-20")
 [1] -6 -3 -2 -1  3  4  5  7  8  9 10 11 14 15 17 18 19 20
