knuth <- function(vec)
{
  last <- length(vec)
  if(last >= 2)
  {
    for(i in last:2)
    {
      j <- sample(seq_len(i), size = 1)
      vec[c(i, j)] <- vec[c(j, i)]
    }
  }
  vec
}
#Demonstration:
knuth(integer(0))
knuth(c(10))
replicate(10, knuth(c(10, 20)))
replicate(10, knuth(c(10, 20, 30)))
knuth(c("Also", "works", "for", "strings"))
