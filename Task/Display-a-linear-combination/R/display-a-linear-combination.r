library(stringr)

basisify <- function(v){
  terms <- character(0)
  for(i in seq_along(v)){
    if(v[i]!=0){
      terms <- c(terms, str_glue("{v[i]}*e({i})"))
    }
  }
  if(length(terms)==0) return(0)
  terms <- str_replace_all(terms, fixed("1*"), "")
  series <- str_flatten(terms, collapse=" + ")
  return(str_replace_all(series, fixed("+ -"), "- "))
}

test_vectors <- list(c(1,2,3),
                     c(0,1,2,3),
                     c(1,0,3,4),
                     c(1,2,0),
                     c(0,0,0),
                     0,
                     c(1,1,1),
                     c(-1,-1,-1),
                     c(-1,-2,0,-3),
                     -1)

print(lapply(test_vectors, basisify), quote=FALSE)
