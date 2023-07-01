tsort <- function(deps) {
	nm <- names(deps)
	libs <- union(as.vector(unlist(deps)), nm)
	
	s <- c()
	# first libs that depend on nothing
	for(x in libs) {
		if(!(x %in% nm)) {
			s <- c(s, x)
		}
	}
	
	k <- 1
	while(k > 0) {
		k <- 0
		for(x in setdiff(nm, s)) {
			r <- c(s, x)
			if(length(setdiff(deps[[x]], r)) == 0) {
				s <- r
				k <- 1
			}
		}
	}
	
	if(length(s) < length(libs)) {
		v <- setdiff(libs, s)
		stop(sprintf("Unorderable items :\n%s", paste("", v, sep="", collapse="\n")))
	}
	
	s
}
