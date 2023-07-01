letter.frequency <- function(filename)
{
    file <- paste(readLines(filename), collapse = '')
    chars <- strsplit(file, NULL)[[1]]
    summary(factor(chars))
}
