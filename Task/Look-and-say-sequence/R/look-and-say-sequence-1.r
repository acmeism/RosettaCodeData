look.and.say <- function(x, return.an.int=FALSE)
{
   #convert number to character vector
   xstr <- unlist(strsplit(as.character(x), ""))
   #get run length encoding
   rlex <- rle(xstr)
   #form new string
   odds <- as.character(rlex$lengths)
   evens <- rlex$values
   newstr <- as.vector(rbind(odds, evens))
   #collapse to scalar
   newstr <- paste(newstr, collapse="")
   #convert to number, if desired
   if(return.an.int) as.integer(newstr) else newstr
}
