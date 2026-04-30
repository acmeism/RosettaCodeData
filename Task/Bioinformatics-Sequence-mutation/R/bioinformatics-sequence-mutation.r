library(stringr)

bases <- c("A", "C", "G", "T")
dna <- sample(bases, 200, replace=TRUE)

mutate_base <- function(v){
  pos <- sample(seq_along(v), 1)
  action <- sample(1:3, 1)
  if(action==1){
    base_swap <- sample(bases, 1)
    print(str_glue("Base {v[pos]} at position {pos} swapped to {base_swap}"))
    v[pos] <- base_swap
  }
  else if(action==2){
    print(str_glue("Base {v[pos]} at position {pos} deleted"))
    v <- v[-pos]
  }
  else if(action==3){
    base_insert <- sample(bases, 1)
    print(str_glue("Base {base_insert} inserted at position {pos}"))
    v <- c(v[1:(pos-1)], base_insert, v[pos:length(v)])
  }
  return(v)
}

count_bases <- function(v){
  base_counts <- sapply(bases, function(s) sum(v==s))
  cat("Base counts:\n")
  cat(paste0(bases, ": ", base_counts), "\n")
  cat("Total:", length(v), "\n")
}

prettify <- function(title, v){
  cat(title, "\n")
  nline <- function(s, n) rep(s, n%%50==0)
  rownum <- function(n) paste0(n, ": ", collapse="")
  for(i in seq_along(v)) cat(nline(rownum(i-1), i-1),
                             v[i],
                             nline("\n", i),
                             sep="")
}

prettify("Initial DNA sequence:", dna)
count_bases(dna)

dna <- Reduce(function(x, f) f(x),
              rep(list(mutate_base), 10),
              init=dna)

prettify("Mutated DNA sequence:", dna)
count_bases(dna)
