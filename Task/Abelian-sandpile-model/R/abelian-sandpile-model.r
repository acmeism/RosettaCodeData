# Return (x,y) index from a grid from an index in a list based on the grid size
pos_to_index <- function(n) {
  f1 <- n/gridsize
  col <- ifelse(n%%gridsize == 0, f1,as.integer(f1)+1)
  row <- n - ((col-1)*gridsize)
  list(row=row,col=col)
}

# Return adjacent indexes (north, east, south, west)
adjacent_indexes <- function(r,c) {
  rup <- r - 1
  rdn <- ifelse(r == gridsize,0,r + 1)
  cleft <- c - 1
  cright <- ifelse(c==gridsize,0,c+1)
  list(up=c(rup,c),right=c(r,cright),left=c(r,cleft),down=c(rdn,c))
}

# Generate Abelian pattern
abelian <- function(gridsize,sand) {
  mat_ <- matrix(rep(0,gridsize^2),gridsize)
  midv <- as.integer(gridsize/2) + 1
  mat_[midv,midv] <- sand
  cat("Before\n")
  print(mat_)

  while(T) {
    cnt <- cnt + 1
    tgt <- which(mat_ >= 4)
    if (length(tgt) == 0) break
    pos   <- pos_to_index(tgt[1])
    idxes <- adjacent_indexes(pos$row,pos$col)
    mat_[pos$row,pos$col] <- mat_[pos$row,pos$col] - 4

    for (i in idxes) if (0 %in% i == F)  mat_[i[1],i[2]] <- mat_[i[1],i[2]] +1
  }
  cat("After\n")
  print(mat_)
}

# Main

abelian(10,64)
