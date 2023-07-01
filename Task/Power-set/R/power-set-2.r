powerset <- function(set){
	ps <- list()
	ps[[1]] <- numeric()						#Start with the empty set.
	for(element in set){						#For each element in the set, take all subsets
		temp <- vector(mode="list",length=length(ps))		#currently in "ps" and create new subsets (in "temp")
		for(subset in 1:length(ps)){				#by adding "element" to each of them.
			temp[[subset]] = c(ps[[subset]],element)
		}
		ps <- c(ps,temp)						#Add the additional subsets ("temp") to "ps".
	}
	ps
}

powerset(1:4)
