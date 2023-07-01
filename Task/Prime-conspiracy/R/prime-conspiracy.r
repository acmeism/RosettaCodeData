suppressMessages(library(gmp))

limit <- 1e6
result <- vector('numeric', 99)
prev_prime <- 2
count <- 0

getOutput <- function(transition) {
	if (result[transition] == 0) return()
	second <- transition %% 10
        first <-  (transition - second) / 10
	cat(first,"->",second,"count:", sprintf("%6d",result[transition]), "frequency:",
            sprintf("%5.2f%%\n",result[transition]*100/limit))
}
	
while (count <= limit) {
	count <- count + 1
	next_prime <- nextprime(prev_prime)
	transition <- 10*(asNumeric(prev_prime) %% 10) + (asNumeric(next_prime) %% 10)
	prev_prime <- next_prime
	result[transition] <- result[transition] + 1
}

cat(sprintf("%d",limit),"first primes. Transitions prime % 10 -> next-prime % 10\n")
invisible(sapply(1:99,getOutput))
