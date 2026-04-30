s <- c(1, 2, 2, 3, 4, 4, 5)

for(i in 1:7){
  curr <- s[i]
  if(i>1 && curr==prev) print(i)
  prev <- curr
}
