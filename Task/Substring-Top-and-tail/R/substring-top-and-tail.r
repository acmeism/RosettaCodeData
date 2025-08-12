top_and_tail <- function(s, top=TRUE, tail=TRUE) substr(s, 1+top, nchar(s)-tail)
top_and_tail("xyzzy")
top_and_tail("xyzzy", top=FALSE)
top_and_tail("xyzzy", tail=FALSE)
