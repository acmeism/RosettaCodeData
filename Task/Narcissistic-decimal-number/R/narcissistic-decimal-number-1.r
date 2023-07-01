for (u in 1:10000000) {
	j <- nchar(u)
	set2 <- c()
	for (i in 1:j) {
		set2[i] <- as.numeric(substr(u, i, i))
		}
	control <- c()
	for (k in 1:j) {
		control[k] <- set2[k]^(j)
		}
	if (sum(control) == u) print(u)
}
