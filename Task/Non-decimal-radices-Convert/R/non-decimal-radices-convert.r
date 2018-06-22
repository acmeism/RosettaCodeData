int2str <- function(x, b) {
	if(x==0) return("0")
	if(x<0) return(paste0("-", base(-x,b)))
	
	map <- c(as.character(0:9), letters)
	res <- ""
	while (x>0) {
		res <- c(map[x %% b + 1], res)
		x <- x %/% b
	}
	return(paste(res, collapse=""))
}

str2int <- function(s, b) {
	map <- c(as.character(0:9), letters)
	s <- strsplit(s,"")[[1]]
	res <- sapply(s, function(x) which(map==x))
	res <- as.vector((res-1) %*% b^((length(res)-1):0))
	return(res)
}

## example: convert 255 to hex (ff):
int2str(255, 16)

## example: convert "1a" in base 16 to integer (26):
str2int("1a", 16)
