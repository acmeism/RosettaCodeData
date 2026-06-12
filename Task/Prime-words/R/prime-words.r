library(stringr)

#Only need to test divisibility up to 11 because 122 is less than 13 squared
testdivisors <- c(2, 3, 5, 7, 11)

primetest <- function(n) !(0 %in% (n%%testdivisors))
primes <- Filter(primetest, 65:122)

chars <- intToUtf8(primes)

regexp <- str_glue("^[{chars}]+$")

unixdict <- readLines(con=url("https://raw.githubusercontent.com/thundergnat/rc-run/refs/heads/master/rc/resources/unixdict.txt"))

primewords <- subset(unixdict, str_detect(unixdict, regexp))
print(primewords, quote=FALSE)
