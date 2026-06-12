#!/usr/bin/env Rscript

meaningOfLife <- function() {
	42
}

# NOTE: args not actually used in this example
main <- function(args) {
	cat("Main: The meaning of life is ", meaningOfLife(), "\n")
}

# Only executes if this script is run directly from the command line
if (length(sys.frames()) == 0) {
	args <- commandArgs(trailingOnly = TRUE)
	main(args)
	q("no")
}
