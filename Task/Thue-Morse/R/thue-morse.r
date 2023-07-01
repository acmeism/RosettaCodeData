thue_morse <- function(steps) {
	sb1 <- "0"
	sb2 <- "1"
	for (idx in 1:steps) {
		tmp <- sb1
		sb1 <- paste0(sb1, sb2)
		sb2 <- paste0(sb2, tmp)
	}
	sb1
}
cat(thue_morse(6), "\n")
