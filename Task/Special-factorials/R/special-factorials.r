superfactorial <- function(n) prod(factorial(1:n))

hyperfactorial <- function(n) prod((1:n)^(1:n))

alt_factorial <- function(n) sum(factorial(1:n)*(-1)^((n:1)-1))

exp_factorial <- function(n) Reduce(`^`, n:1, right=TRUE)

inv_factorial <- function(n){
  est <- ceiling(1+log(n)) #This is always at least equal to the inverse factorial of n
  out <- match(n, factorial(0:est))-1
  if(is.na(out)){
    cat("undefined")
  }
  else return(out)
}

factorials <- sapply(c(superfactorial, hyperfactorial, alt_factorial), function(f) sapply(0:9, f))
colnames(factorials) <- c("sf", "hf", "af")
rownames(factorials) <- 0:9
print(factorials)
cat(sapply(0:4, exp_factorial))
cat(sapply(c(1,2,6,24,120,720,5040,40320,362880,3628800), inv_factorial))
inv_factorial(119)

#Alternate method for exponential factorial, provided as an example of how to use eval()
library(stringr)

exp_factorial <- function(n){
  if(n %in% c(0,1)) return(n)
  vec <- as.character((n-1):1)
  formula <- str_replace_all(vec, "^(?=[1-9])", "^(")
  formula_assembled <- str_c(as.character(n), str_flatten(formula), str_dup(")", n-1))
  eval(str2lang(formula_assembled))
}
