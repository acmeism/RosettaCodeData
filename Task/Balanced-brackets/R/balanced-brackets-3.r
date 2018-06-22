rand.parens <- function(n) paste(sample(c("[","]"),2*n,replace=T),collapse="")

as.data.frame(within(list(), {
  parens <- replicate(10, rand.parens(sample.int(10,size=1)))
  balanced <- sapply(parens, balanced)
}))
