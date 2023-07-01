largest_proper_divisor <- function(n){
  if(n == 1) return(1)

  lpd = 1

  for(i in seq(1, n-1, 1)){
    if(n %% i == 0)
      lpd = i
  }

  message(paste0("The largest proper divisor of ", n, " is ", lpd))
  return(lpd)
}

#Verify
for (i in 1:100){       #about 10 seconds to calculate until 10000
  largest_proper_divisor(i)
}
