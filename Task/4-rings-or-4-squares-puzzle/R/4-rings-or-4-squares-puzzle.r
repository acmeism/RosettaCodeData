# 4 rings or 4 squares puzzle

perms <- function (n, r, v = 1:n, repeats.allowed = FALSE) {
  if (repeats.allowed)
    sub <- function(n, r, v) {
      if (r == 1)
        matrix(v, n, 1)
      else if (n == 1)
        matrix(v, 1, r)
      else {
        inner <- Recall(n, r - 1, v)
        cbind(rep(v, rep(nrow(inner), n)), matrix(t(inner),
                                                  ncol = ncol(inner), nrow = nrow(inner) * n,
                                                  byrow = TRUE))
      }
    }
  else sub <- function(n, r, v) {
    if (r == 1)
      matrix(v, n, 1)
    else if (n == 1)
      matrix(v, 1, r)
    else {
      X <- NULL
      for (i in 1:n) X <- rbind(X, cbind(v[i], Recall(n - 1, r - 1, v[-i])))
      X
    }
  }
  X <- sub(n, r, v[1:n])

  result <- vector(mode = "numeric")

  for(i in 1:nrow(X)){
    y <- X[i, ]
    x1 <- y[1] + y[2]
    x2 <- y[2] + y[3] + y[4]
    x3 <- y[4] + y[5] + y[6]
    x4 <- y[6] + y[7]
    if(x1 == x2 & x2 == x3 & x3 == x4) result <- rbind(result, y)
  }
  return(result)
}

print_perms <- function(n, r, v = 1:n, repeats.allowed = FALSE, table.out = FALSE) {
  a <- perms(n, r, v, repeats.allowed)
  colnames(a) <- rep("", ncol(a))
  rownames(a) <- rep("", nrow(a))
  if(!repeats.allowed){
    print(a)
    cat(paste('\n', nrow(a), 'unique solutions from', min(v), 'to', max(v)))
  } else {
    cat(paste('\n', nrow(a), 'non-unique solutions from', min(v), 'to', max(v)))
  }
}

registerS3method("print_perms", "data.frame", print_perms)

print_perms(7, 7, repeats.allowed = FALSE, table.out = TRUE)
print_perms(7, 7, v = 3:9, repeats.allowed = FALSE, table.out = TRUE)
print_perms(10, 7, v = 0:9, repeats.allowed = TRUE, table.out = FALSE)
