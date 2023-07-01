passwords <- function(nl = 8, npw = 1, help = FALSE) {
  if (help) return("gives npw passwords with nl characters each")
  if (nl < 4) nl <- 4
  spch <- c("!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "]", "^", "_", "{", "|", "}", "~")
  for(i in 1:npw) {
    pw <- c(sample(letters, 1), sample(LETTERS, 1), sample(0:9, 1), sample(spch, 1))
    pw <- c(pw, sample(c(letters, LETTERS, 0:9, spch), nl-4, replace = TRUE))
    cat(sample(pw), "\n", sep = "")
  }
}

set.seed(123)
passwords(help = TRUE)
## [1] "gives npw passwords with nl characters each"

passwords(8)
## S2XnQoy*

passwords(14, 5)
## :.iJ=Q7_gP?Cio
## !yUu7OL|eH;}1p
## y2{DNvV^Zl^IFe
## Tj@T19L.q1;I*]
## 6M+{)xV?i|1UJ/
