is.luhn <- function(cc){
  numbers <- as.numeric(rev(unlist(strsplit(cc,""))))
  (sum(numbers[seq(1,length(numbers),by=2)]) + sum({numbers[seq(2,length(numbers),by=2)]*2 ->.;  .%%10 +.%/%10})) %% 10 == 0
}

sapply(c("49927398716","49927398717","1234567812345678","1234567812345670"),is.luhn)
