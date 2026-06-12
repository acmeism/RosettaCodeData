library(stringr)

#Maximum difference in codes is 122-65=57, so only primes up to this value need to be used
#Only need to test divisibility up to 7 (57 is less than 11 squared)
testdivisors <- c(2,3,5,7)
primetest <- function(n) !(0 %in% (n%%testdivisors))
primes <- c(testdivisors, Filter(primetest, 8:57))

prime_group <- function(s, n){
  codes <- sapply(str_split_1(s, ""), utf8ToInt)
  groups <- combn(codes, n, simplify=FALSE)
  diffs <- lapply(groups, function(v) abs(v-c(v[-1], v[1])))
  for(d in diffs){
    if(all(d %in% primes)){
      out <- d |> names() |> str_flatten()
      return(out)
    }
  }
  return("Not found.")
}

test_strings <- c("riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja")
allgroups <- function(n) sapply(test_strings, function(s) prime_group(s, n))
writeLines(c(allgroups(3), "", allgroups(2)))
