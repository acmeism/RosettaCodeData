conv <- function(a, b) {
	p <- length(a)
	q <- length(b)
	n <- p + q - 1
	r <- nextn(n, f=2)
	y <- fft(fft(c(a, rep(0, r-p))) * fft(c(b, rep(0, r-q))), inverse=TRUE)/r
	y[1:n]
}

deconv <- function(a, b) {
	p <- length(a)
	q <- length(b)
	n <- p - q + 1
	r <- nextn(max(p, q), f=2)
	y <- fft(fft(c(a, rep(0, r-p))) / fft(c(b, rep(0, r-q))), inverse=TRUE)/r
	return(y[1:n])
}
