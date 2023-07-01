library(gmp)

emirp <- function(start = 1, end = Inf, howmany = Inf, ignore = 0) {
	count <- 0
	p <- start

	while (count<howmany+ignore && p <= end) {
		p <- nextprime(p)
		p_reverse <- as.bigz(paste0(rev(unlist(strsplit(as.character(p), ""))), collapse = ""))
		if (p != p_reverse && isprime(p_reverse) > 0) {
			if (count >= ignore) cat(as.character(p)," ",sep="")
			count <- count + 1
		}
	}
	cat("\n")
}
cat("First 20 emirps: ")
emirp(howmany = 20)

cat("Emirps between 7700 and 8000: ")
emirp(start = 7700, end = 8000)

cat("The 10000th emirp: ")
emirp(ignore = 9999, howmany = 1)
