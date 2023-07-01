pbenford <- function(d){
  return(log10(1+(1/d)))
}

get_lead_digit <- function(number){
  return(as.numeric(substr(number,1,1)))
}

fib_iter <- function(n){
  first <- 1
  second <- 0
  for(i in 1:n){
    sum <- first + second
    first <- second
    second <- sum
  }
  return(sum)
}

fib_sequence <- mapply(fib_iter,c(1:1000))
lead_digits <- mapply(get_lead_digit,fib_sequence)

observed_frequencies <- table(lead_digits)/1000
expected_frequencies <- mapply(pbenford,c(1:9))

data <- data.frame(observed_frequencies,expected_frequencies)
colnames(data) <- c("digit","obs.frequency","exp.frequency")
dev_percentage <- abs((data$obs.frequency-data$exp.frequency)*100)
data <- data.frame(data,dev_percentage)

print(data)
