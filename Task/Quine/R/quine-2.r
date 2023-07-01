src <- "\nwriteLines(c(paste(\"src <-\", encodeString(src, quote='\"')), src))"

writeLines(c(paste("src <-", encodeString(src, quote='"')), src))
