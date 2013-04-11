library(gtools)

solve24 <- function(vals=c(8, 4, 2, 1),
                    goal=24,
                    ops=c("+", "-", "*", "/")) {

  val.perms <- as.data.frame(t(
                  permutations(length(vals), length(vals))))

  nop <- length(vals)-1
  op.perms <- as.data.frame(t(
                  do.call(expand.grid,
                          replicate(nop, list(ops)))))

  ord.perms <- as.data.frame(t(
                   do.call(expand.grid,
                           replicate(n <- nop, 1:((n <<- n-1)+1)))))

  for (val.perm in val.perms)
    for (op.perm in op.perms)
      for (ord.perm in ord.perms)
        {
          expr <- as.list(vals[val.perm])
          for (i in 1:nop) {
            expr[[ ord.perm[i] ]] <- call(as.character(op.perm[i]),
                                          expr[[ ord.perm[i]   ]],
                                          expr[[ ord.perm[i]+1 ]])
            expr <- expr[ -(ord.perm[i]+1) ]
          }
          if (identical(eval(expr[[1]]), goal)) return(expr[[1]])
        }

  return(NA)
}
