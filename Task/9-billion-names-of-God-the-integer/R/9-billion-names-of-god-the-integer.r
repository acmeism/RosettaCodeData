library(partitions)
library(stringi)

get_row <- function(x) unname(table(parts(x)[1,]))

center_string <- function(s,pad_len=80) stri_pad_both(s,(pad_len - length(s))," ")

for (i in 1:25) cat(center_string(stri_c(get_row(i),collapse = " "),80),"\n")

cat("The sum of G(25) is:", sum(get_row(25)),"\n")
