# Abundant Odd Numbers

find_div_sum <- function(x){
  # Finds sigma: the sum of the divisors (not including the number itself) of an odd number
  if (x < 16) return(0)
  root <- sqrt(x)
  vec <- as.vector(1)
  for (i in seq.int(3, root - 1, by = 2)){
    if(x %% i == 0){
      vec <- c(vec, i, x/i)
    }
  }
  if (root == trunc(root)) vec = c(vec, root)
  return(sum(vec))
}

get_n_abun <- function(index = 1, total = 25, print_all = TRUE){
  # Finds a total of 'total' abundant odds starting with 'index', with print option
  n <- 1
  while(n <= total){
    my_sum <- find_div_sum(index)
    if (my_sum > index){
      if(print_all) cat(index, "..... sigma is", my_sum, "\n")
      n <- n + 1
    }
    index <- index + 2
  }
  if(!print_all) cat(index - 2, "..... sigma is", my_sum, "\n")
}

# Get first 25
cat("The first 25 abundants are")
get_n_abun()

# Get the 1000th
cat("The 1000th odd abundant is")
get_n_abun(total = 1000, print_all = F)

# Get the first after 1e9
cat("First odd abundant after 1e9 is")
get_n_abun(index = 1e9 + 1, total = 1, print_all = F)
