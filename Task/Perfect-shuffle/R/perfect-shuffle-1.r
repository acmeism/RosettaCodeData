wave.shuffle <- function(n) {
  deck <- 1:n ## create the original deck
  new.deck <- c(matrix(data = deck, ncol = 2, byrow = TRUE)) ## shuffle the deck once
  counter <- 1 ## track the number of loops
  ## defining a loop that shuffles the new deck until identical with the original one
  ## and in the same time increses the counter with 1 per loop
  while (!identical(deck, new.deck)) { ## logical condition
    new.deck <- c(matrix(data = new.deck, ncol = 2, byrow = TRUE)) ## shuffle
    counter <- counter + 1 ## add 1 to the number of loops
  }
  return(counter) ## final result - total number of loops until the condition is met
}
test.values <- c(8, 24, 52, 100, 1020, 1024, 10000) ## the set of the test values
test <- sapply(test.values, wave.shuffle) ## apply the wave.shuffle function on each element
names(test) <- test.values ## name the result
test ## print the result out
