Largest_int_from_concat_ints <- function(vec){

  #recursive function for computing all permutations
  perm <- function(vec) {
    n <- length(vec)
    if (n == 1)
      return(vec)
    else {
      x <- NULL
      for (i in 1:n){
        x <- rbind(x, cbind(vec[i], perm(vec[-i])))
      }
      return(x)
    }
  }

  permutations <- perm(vec)
  concat <- as.numeric(apply(permutations, 1, paste, collapse = ""))
  return(max(concat))
}

#Verify
Largest_int_from_concat_ints(c(54, 546, 548, 60))
Largest_int_from_concat_ints(c(1, 34, 3, 98, 9, 76, 45, 4))
Largest_int_from_concat_ints(c(93, 4, 89, 21, 73))
