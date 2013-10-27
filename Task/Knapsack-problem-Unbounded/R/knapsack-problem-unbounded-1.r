# Define consts
weights <- c(panacea=0.3, ichor=0.2, gold=2.0)
volumes <- c(panacea=0.025, ichor=0.015, gold=0.002)
values <- c(panacea=3000, ichor=1800, gold=2500)
sack.weight <- 25
sack.volume <- 0.25
max.items <- floor(pmin(sack.weight/weights, sack.volume/volumes))

# Some utility functions
getTotalValue <- function(n) sum(n*values)
getTotalWeight <- function(n) sum(n*weights)
getTotalVolume <- function(n) sum(n*volumes)
willFitInSack <- function(n) getTotalWeight(n) <= sack.weight && getTotalVolume(n) <= sack.volume

# Find all possible combination, then eliminate those that won't fit in the sack
knapsack <- expand.grid(lapply(max.items, function(n) seq.int(0, n)))
ok <- apply(knapsack, 1, willFitInSack)
knapok <- knapsack[ok,]

# Find the solutions with the highest value
vals <- apply(knapok, 1, getTotalValue)
knapok[vals == max(vals),]
