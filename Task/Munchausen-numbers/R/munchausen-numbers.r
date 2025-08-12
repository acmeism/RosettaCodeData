exp_digsum <- function(n) ifelse(n>9, (n%%10)^(n%%10)+exp_digsum(n%/%10), n^n)

for(i in 1:5000){
  if(exp_digsum(i)==i) print(i)
}
