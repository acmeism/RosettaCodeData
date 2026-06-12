#Use a combinatorial approach to generate all 3 and 4-digit undulating numbers
seeds <- combn(0:9, 2)
threes_1 <- rbind(seeds, seeds[1,])
threes_2 <- rbind(seeds[2,], seeds)
threes_full <- cbind(threes_1, threes_2)
construct_num <- function(v) paste0(v, collapse="") |> as.numeric()
threes <- apply(threes_full, 2, construct_num)
threes <- subset(threes, threes>100) |> sort() |> print()

fours_1 <- rbind(seeds, seeds)
fours_2 <- rbind(seeds[2,], seeds, seeds[1,])
fours_full <- cbind(fours_1, fours_2)
fours <- apply(fours_full, 2, construct_num)
fours <- subset(fours, fours>1000) |> sort() |> print()

#To find 3-digit primes, test divisibility up to 31 (989 is less than 37 squared)
testdivisors <- c(2,3,5,7,11,13,17,19,23,29,31)
primetest <- function(n) !(0 %in% (n%%testdivisors))
Filter(primetest, threes)

#There are exactly 81 undulating numbers with n digits for each n>2
#(This is because there are 9 of them starting with each digit 1-9)
#Hence, the kth will be k mod 81 along the "sequence", and have 3+k int/ 81 digits
seeds_df <- cbind(seeds, seeds[2:1,]) |> t() |> as.data.frame()
seeds_df <- subset(seeds_df, V1!=0) |> sort_by(~V1+V2)
kth_undul <- function(k) rep(seeds_df[k%%81,], length.out=k%/%81+3) |> construct_num()
kth_undul(600)

#Working out the undulating number count below a value follows similar logic
#We don't cast numbers to strings here because 2^53 is big enough that R uses scientific notation
numdigits <- function(n) ceiling(log10(n))
first2digits <- function(n) n%/%(10^(numdigits(n)-2))
#But working digit by digit it won't have unintended behaviour
gen_undul <- function(n, d){
  dig1 <- n%/%10
  dig2 <- n%%10
  rep(c(dig1, dig2), length.out=d) |> construct_num()
}

num_unduls <- function(n){
  m <- numdigits(n)
  seed <- first2digits(n)
  dig1 <- seed%/%10
  dig2 <- seed%%10
  index <- with(seeds_df, V1==dig1&V2==dig2) |> which()
  nu <- (m-3)*81+index
  ifelse(n<=gen_undul(seed, m), nu-1, nu)
}

num_unduls(2^53)

#Generating the greatest undulating number below a value is now easy:
last_undul <- function(n){
  m <- numdigits(n)
  seed <- first2digits(n)
  test_undul <- gen_undul(seed, m)
  ifelse(n<=test_undul, gen_undul(seed-1, m), test_undul)
}

print(last_undul(2^53), digits=numdigits(2^53))
