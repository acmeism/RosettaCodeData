doors_puzzle <- function(ndoors, passes = ndoors) {
    doors <- logical(ndoors)
    for (ii in seq(passes)) {
        mask <- seq(ii, ndoors, ii)
        doors[mask] <- !doors[mask]	
    }
    which(doors)
}

doors_puzzle(100)
