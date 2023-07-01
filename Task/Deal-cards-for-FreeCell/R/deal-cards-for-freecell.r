## Linear congruential generator code not original -
## copied from
## http://www.rosettacode.org/wiki/Linear_congruential_generator#R
## altered to allow seed as an argument

library(gmp) # for big integers

rand_MS <- function(n = 1, seed = 1) {
  a <- as.bigz(214013)
  c <- as.bigz(2531011)
  m <- as.bigz(2^31)
  x <- rep(as.bigz(0), n)
  x[1] <- (a * as.bigz(seed) + c) %% m
  i <- 1
  while (i < n) {
    x[i+1] <- (a * x[i] + c) %% m
    i <- i + 1
  }
  as.integer(x / 2^16)
}

## =============================
## New code follows:
## =============================

dealFreeCell <- function(seedNum) {
  deck <- paste(rep(c("A",2,3,4,5,6,7,8,9,10,"J","Q","K"), each = 4), c("C","D","H","S"), sep = "")
  cards = rand_MS(52,seedNum)

  for (i in 52:1) {
    cardToPick <- (cards[53-i]%% i)+1 # R indexes from 1, not 0
    deck[c(cardToPick,i)] <- deck[c(i, cardToPick)]
  }

  deck <- rev(deck) # flip the deck to deal
  deal = matrix(c(deck,NA,NA,NA,NA),ncol = 8, byrow = TRUE)
  # using a matrix for simple printing, but requires filling with NA
  # if implementing as a game, a list for each pile would make more sense
  print(paste("Hand numer:",seedNum), quote = FALSE)
  print(deal, quote = FALSE, na.print = "")
}
