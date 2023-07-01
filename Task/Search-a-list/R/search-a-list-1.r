find.needle <- function(haystack, needle="needle", return.last.index.too=FALSE)
{
   indices <- which(haystack %in% needle)
   if(length(indices)==0) stop("no needles in the haystack")
   if(return.last.index.too) range(indices) else min(indices)
}
