library(gmp)

print_20digits <- function(z){
  s <- as.character(z)
  if(nchar(s)>40){
    paste0(substring(s, 1, 20), "...", substring(s, nchar(s)-19, nchar(s)))
  }
  else return(s)
}

count <- 0
n <- 1
while(count<33){
  plus <- factorialZ(n)+1
  minus <- factorialZ(n)-1
  if(isprime(plus)!=0){
    cat(n, "!+1 = ", print_20digits(plus),
        " (", nchar(as.character(plus)), " digits)",
        "\n", sep="")
    count <- count+1
  }
  if(isprime(minus)!=0){
    cat(n, "!-1 = ", print_20digits(minus),
        " (", nchar(as.character(minus)), " digits)",
        "\n", sep="")
    count <- count+1
  }
  n <- n+1
}
