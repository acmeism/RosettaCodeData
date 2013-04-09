rand.parens <- function(n) paste(permute(c(rep('[',n),rep(']',n))),collapse="")

as.data.frame(within(list(), {
  parens <- replicate(10, rand.parens(sample.int(10,size=1)))
  balanced <- sapply(parens, balanced)
}))
