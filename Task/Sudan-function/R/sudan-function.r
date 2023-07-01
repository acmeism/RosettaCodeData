#Aamrun, 11th July 2022

F <- function(n, x, y) {
  if(n==0){
  	F <- x+y
    return (F)
  }

  else if(y == 0) {
    F <- x
    return (F)
  }

  F <- F(n - 1, F(n, x, y - 1), F(n, x, y - 1) + y)
  return (F)
}

print(paste("F(1,3,3) = " , F(1,3,3)))
