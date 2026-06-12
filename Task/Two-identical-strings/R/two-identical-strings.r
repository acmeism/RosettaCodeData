library(e1071)

gen_binconcat <- function(v) paste0(c(1, v, 1, v), collapse="")
all_concats <- function(n) apply(bincombinations(n), 1, gen_binconcat)
bin <- c("11", unlist(lapply(1:4, all_concats)))
dec <- Filter(function(n) n<1000, strtoi(bin, base=2))
print(cbind("decimal"=dec, "binary"=bin[seq_along(dec)]), quote=FALSE)
