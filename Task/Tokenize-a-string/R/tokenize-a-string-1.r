text <- "Hello,How,Are,You,Today"
junk <- strsplit(text, split=",")
print(paste(unlist(junk), collapse="."))
