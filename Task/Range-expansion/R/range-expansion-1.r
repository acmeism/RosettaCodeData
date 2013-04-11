rangeExpand <- function(text) {
	x <- unlist(strsplit(text, ","))		# split the string on commas
	x <- gsub("(\\d)-", "\\1:", x)			# substitute dashes following a digit with a colon
	lst <- list(mode = "list", length = length(x))	# an empty list to hold evaluated elements
	for (i in 1:length(x)) {			# evaluate each element and add to the list
		lst[[i]] <- eval(parse(text = x[i]))
	}
	unlist(lst, use.names = FALSE)			# return the expanded integers
}
