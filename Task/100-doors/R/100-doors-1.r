doors_puzzle <- function(ndoors=100,passes=100) {
    doors <- rep(FALSE,ndoors)
    for (ii in seq(1,passes)) {
        mask <- seq(0,ndoors,ii)
        doors[mask] <- !doors[mask]	
    }
    return (which(doors == TRUE))
}

doors_puzzle()
