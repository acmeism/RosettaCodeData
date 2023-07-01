library(gmp)

left_factorial <- function(n) {
	if (n == 0) return(0)
	result <- as.bigz(0)

	adder <- as.bigz(1)	
	for (k in 1:n) {
		result <- result + adder
		adder <- adder * k
	}
	result
}

digit_count <- function(n) {
	nchar(as.character(n))
}

for (n in 0:10) {
	cat("!",n," = ",sep = "")
	cat(as.character(left_factorial(n)))
	cat("\n")
}
for (n in seq(20,110,10)) {
	cat("!",n," = ",sep = "")
	cat(as.character(left_factorial(n)))
	cat("\n")
}
for (n in seq(1000,10000,1000)) {
  cat("!",n," has ",digit_count(left_factorial(n))," digits\n", sep = "")
}
