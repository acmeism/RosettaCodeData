library(RcppAlgos)
permuSort <- function(list)
{
  iter <- permuteIter(list)
  while(is.unsorted(iter$nextIter())){}#iter$nextIter advances iter to the next iteration and returns it.
  iter$currIter()
}
test <- sample(10)
print(test)
permuSort(test)
