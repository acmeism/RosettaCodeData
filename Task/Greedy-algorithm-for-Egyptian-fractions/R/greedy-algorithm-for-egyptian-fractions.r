library(gmp)

next_denom <- function(x,y) (mod.bigz(y,x)>0)+y%/%x

greedy_egyptian <- function(a,b){
  x <- as.bigz(a)
  y <- as.bigz(b)
  fracs <- NULL
  if(x>y){
    fracs <- c(x%/%y, fracs)
    x <- mod.bigz(x, y)
    if(x==0) return(fracs)
  }
  fracs <- c(1/next_denom(x,y), fracs)
  while(mod.bigz(y,x)>0){
    x_new <- mod.bigz(-y, x)
    y_new <- y*(1+y%/%x)
    x <- x_new
    y <- y_new
    fracs <- c(1/next_denom(x,y), fracs)
  }
  return(rev(fracs))
}

test_fracs <- lapply(list(c(43,48), c(5,121), c(2014,59)), as.list)
representations <- lapply(test_fracs, function(l) do.call(greedy_egyptian, l))
names(representations) <- c("43/48","5/121","2014/59")
print(representations, initLine=FALSE)

len <- function(x,y) length(greedy_egyptian(x,y))
last_denoms <- lengths <- matrix.bigz(nrow=98, ncol=98)
for(i in 2:99){
  for(j in 2:99){
    lengths[i-1,j-1] <- len(i,j)
    last_denoms[i-1,j-1] <- denominator(greedy_egyptian(i,j)[len(i,j)])
  }
}

lmax <- max(lengths)
lmax_inds <- which(lengths==max(lengths), arr.ind=TRUE)
cat(sprintf("%i/%i has maximum length of %s:", 1+lmax_inds[1], 1+lmax_inds[2], lmax),"\n")
print(greedy_egyptian(1+lmax_inds[1], 1+lmax_inds[2]), initLine=FALSE)

dmax_inds <- which(last_denoms==max(last_denoms), arr.ind=TRUE)
cat(sprintf("%i/%i contains the largest denominator:", 1+dmax_inds[1], 1+dmax_inds[2]),"\n")
print(greedy_egyptian(1+dmax_inds[1], 1+dmax_inds[2]), initLine=FALSE)
