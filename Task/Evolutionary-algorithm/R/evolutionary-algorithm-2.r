# Setup
set.seed(42)
target= unlist(strsplit("METHINKS IT IS LIKE A WEASEL", ""))
chars= c(LETTERS, " ")
C= 100

# Fitness function; high value means higher fitness
fitness= function(x){
  sum(x == target)
}

# Mutate function
mutate= function(x, rate= 0.01){
  idx= which(runif(length(target)) <= rate)
  x[idx]= replicate(n= length(idx), expr= sample(x= chars, size= 1, replace= T))
  x
}

# Evolve function
evolve= function(x){
  parents= rep(list(x), C+1) # Repliction
  parents[1:C]= lapply(parents[1:C], function(x) mutate(x)) # Mutation
  idx= which.max(lapply(parents, function(x) fitness(x))) # Selection
  parents[[idx]]
}

# Initialize first parent
parent= sample(x= chars, size= length(target), replace= T)

# Main program
while (fitness(parent) < fitness(target)) {
  parent= evolve(parent)
  cat(paste0(parent, collapse=""), "\n")
}
