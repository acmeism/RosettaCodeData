#First define matrix exponentiation (R doesn't natively have this)
`%^%` <- function(mat, n) Reduce(`%*%`, rep(list(mat), n))

#For the nth Fibonacci-like sequence Fn, this function generates the matrix
#that will transform the vector (Fn_k, Fn_k-1, ..., Fn_k-n) to the vector
#(Fn_k+1, Fn_k, ..., Fn_k-n+1) i.e. determine the next member of the sequence
fibmat <- function(n) {
  id <- diag(1, n-1, n-1)
  mat <- rbind(rep(1, n-1), id)
  cbind(mat, c(1, rep(0, n-1)))
}

#This function generates a vector of initial values (which, you will notice from
#looking at the sequences, are always 1 followed by the first n-1 powers of 2)
gen_init <- function(n) rev(c(1, 2^(2:n-2)))

#Now it's easy to define any Fibonacci-like n-step sequence
fiblike <- function(n) function(t) {
  if (t <= n) {
    rev(gen_init(n))[t]
  } else {
    (fibmat(n) %^% (t-n) %*% gen_init(n))[1]
  }
}

lucas <- function(k){
  if (k <= 2) {
    c(2, 1)[k]
  } else {
    (fibmat(2) %^% (k-2) %*% c(1, 2))[1]
  }
}

seqnames <- c("fibo", "tribo", "tetra", "penta", "hexa",
              "hepta", "octa", "nona", "deca") |> paste0("nacci")

for (i in 2:10) cat(seqnames[i-1], "|", sapply(1:15, fiblike(i)), "\n")
cat("lucas |", sapply(1:15, lucas), "\n")
