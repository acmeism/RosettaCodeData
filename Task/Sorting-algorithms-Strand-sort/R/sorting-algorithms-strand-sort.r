merge_vec <- function(left, right){
  result <- numeric(0)
  while(length(left)>0&&length(right)>0){
    if(left[1]<=right[1]){
      result <- c(result, left[1])
      left <- left[-1]
    }
    else {
      result <- c(result, right[1])
      right <- right[-1]
    }
  }
  if(length(left) > 0) result <- c(result, left)
  if(length(right) > 0) result <- c(result, right)
  return(result)
}

strandsort <- function(v){
  if(length(v)==0) stop("input vector cannot be empty")
  strand <- v[1]
  v <- v[-1]
  sorted <- numeric(0)
  while(length(v)>0){
    k <- length(strand)
    for(i in seq_along(v)){
      if(v[i]>strand[k]){
        strand <- c(strand, v[i])
        v <- v[-i]
        break
      }
    }
    if(length(strand)==k){
      sorted <- merge_vec(sorted, strand)
      strand <- v[1]
      v <- v[-1]
    }
  }
  return(sorted)
}

strandsort(c(5,1,4,2,0,9,6,3,8,7))
