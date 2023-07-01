f1 <- function(...){print("coucou")}

f2 <-function(f,n){
lapply(seq_len(n),eval(f))
}

f2(f1,4)
