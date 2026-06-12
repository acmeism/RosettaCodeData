#Method 1: quartic equation
moser_1 <- function(n) (n^4-6*n^3+23*n^2-18*n+24)/24

#Method 2: binomial sum
moser_2 <- function(n) choose(n, 4)+choose(n, 2)+1

#Method 3: binomial transform
binom_term <- function(v, n) sum(choose(n, 0:n)*v[1:n])
moser_3 <- function(n) binom_term(c(rep(1, 5), rep(0, n)), n-1)

#Method 4: Pascal's triangle
moser_4 <- function(n){
  lim <- ifelse(n<5, n-1, 4)
  sum(choose(n-1, 0:lim))
}

results <- lapply(c(moser_1, moser_2, moser_3, moser_4), function(f) sapply(1:20, f))
setNames(results, paste("Method", 1:4))
