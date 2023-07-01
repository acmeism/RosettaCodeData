visited <- vector('logical', 1e8)

terms <- vector('numeric')

in_a_interval <- function(v) {
	visited[[v+1]]
}

add_value <- function(v) {
	visited[[v+1]] <<- TRUE
	terms <<- append(terms, v)
}

add_value(0)
step <- 1
value <- 0

founddup <- FALSE

repeat {
	if ((value-step>0) && (!in_a_interval(value-step))) {
		value <- value - step
	} else {
		value <- value + step
	}
	if (in_a_interval(value) && !founddup) {
		cat("The first duplicated term is a[",step,"] = ",value,"\n", sep = "")
		founddup <- TRUE
	}
	add_value(value)
	if (all(visited[1:1000])) {
		cat("Terms up to a[",step,"] are needed to generate 0 to 1000\n",sep = "")
		break
	}
	step <- step + 1
	if (step == 15) {
		cat("The first 15 terms are :")
		for (aterm in terms) { cat(aterm," ", sep = "") }
		cat("\n")
	}
}
