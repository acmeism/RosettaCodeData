sierpinski.triangle = function(n) {
	c(paste(ifelse(b<<- c(rep(FALSE,2^(n+1)/2),TRUE,rep(FALSE,2^(n+1)/2)),"*"," "),collapse=""),replicate(2^n-1,paste(ifelse(b<<-xor(c(FALSE,b[1:2^(n+1)]),c(b[2:(2^(n+1)+1)],FALSE)),"*"," "),collapse="")))
}
cat(sierpinski.triangle(5),sep="\n")
