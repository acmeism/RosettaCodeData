sattolo <- function(vec)
{
  last <- length(vec)
  if(last >= 2)
  {
    for(i in last:2)
    {
      j <- sample(seq_len(i - 1), size = 1)
      vec[c(i, j)] <- vec[c(j, i)]
    }
  }
  vec
}
#Demonstration:
sattolo(integer(0))
sattolo(c(10))
replicate(10, sattolo(c(10, 20)))
replicate(10, sattolo(c(10, 20, 30)))
sattolo(c(11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22))
sattolo(c("Also", "works", "for", "strings"))
