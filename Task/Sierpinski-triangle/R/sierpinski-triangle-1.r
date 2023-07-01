sierpinski.triangle = function(n) {
	len <- 2^(n+1)
	b <- c(rep(FALSE,len/2),TRUE,rep(FALSE,len/2))
	for (i in 1:(len/2))
	{
		cat(paste(ifelse(b,"*"," "),collapse=""),"\n")
		n <- rep(FALSE,len+1)
		n[which(b)-1]<-TRUE
		n[which(b)+1]<-xor(n[which(b)+1],TRUE)
		b <- n
	}
}
sierpinski.triangle(5)
