runlengthencoding <- function(x)
{
   splitx <- unlist(strsplit(input, ""))
   rlex <- rle(splitx)
   paste(with(rlex, as.vector(rbind(lengths, values))), collapse="")
}

input <- "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
runlengthencoding(input)
