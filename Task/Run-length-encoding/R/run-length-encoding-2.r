inverserunlengthencoding <- function(x)
{
    lengths <- as.numeric(unlist(strsplit(output, "[[:alpha:]]")))
    values <- unlist(strsplit(output, "[[:digit:]]"))
    values <- values[values != ""]
    uncompressed <- inverse.rle(list(lengths=lengths, values=values))
    paste(uncompressed, collapse="")
}

output <- "12W1B12W3B24W1B14W"
inverserunlengthencoding(output)
