insertion_sort <- function(x) {
  for (j in 2:length(x)) {
    key <- x[j]
    bp <- which.max(x[1:j] > key)
    # 'bp' stands for breakpoint
    if (bp == 1) {
      if (key < ar[1]){
          x <- c(key, ar[-j])
      }
    }
    else {
      x <- x[-j]
      x <- c(ar[1:bp - 1], key, x[bp : (s-1)])
    }
  return(x)
  }
}
