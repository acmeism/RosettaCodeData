is.luhn <- function(cc){
	numbers <- as.numeric(rev(unlist(strsplit(cc,""))))
	mod(sum({numbers[seq(2,length(numbers),by=2)]*2 ->.; mod(.,10)+.%/%10}) +
		sum(numbers[seq(1,length(numbers),by=2)]), 10)==0
}
