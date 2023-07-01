library(gmp)
leftFact <- function(numbs)
{
  #As we will never actually use the numeric values of our outputs, we will
  #immediately coerce them to characters. For technical reasons to do with
  #nchar misbehaving, this also makes task 3 much easier.
  #As task 1 will demonstrate, the n=0 special case is covered.
  sapply(numbs, function(n) as.character(sum(factorialZ(seq_len(n)-1))))
}
printer <- function(inputs) print(data.frame(Value = leftFact(inputs), row.names = paste0("!", inputs)))

#Task 1
printer(0:10)
#Task 2
printer(seq(20, 110, by = 10))
#Task 3
inputs<-seq(1000, 10000, by = 1000)
print(data.frame(Digits = sapply(leftFact(inputs), nchar), row.names = paste0("!", inputs)))
