lex_compare <- function(v1, v2){
  ldiff <- length(v1)-length(v2)
  endstate <- ldiff<0
  iters <- ifelse(endstate, length(v1), length(v2))
  for(i in seq_len(iters)){
    if(v1[i]==v2[i]) next
    else return(v1[i]<v2[i])
  }
  return(endstate)
}

lex_compare(c(1,2,1,3,2), c(1,2,0,4,4,0,0,0))
lex_compare(1, numeric(0))
lex_compare(numeric(0), 1)
