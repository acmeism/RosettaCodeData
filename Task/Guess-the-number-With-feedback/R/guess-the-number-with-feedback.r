guessANumber <- function(low, high)
{
  boundryErrorCheck(low, high)
  goal <- sample(low:high, size = 1)
  guess <- getValidInput(paste0("I have a whole number between ", low, " and ", high, ". What's your guess? "))
  while(guess != goal)
  {
    if(guess < low || guess > high){guess <- getValidInput("Out of range! Try again "); next}
    if(guess > goal){guess <- getValidInput("Too high! Try again "); next}
    if(guess < goal){guess <- getValidInput("Too low! Try again "); next}
  }
  "Winner!"
}

boundryErrorCheck <- function(low, high)
{
  if(!is.numeric(low) || as.integer(low) != low) stop("Lower bound must be an integer. Try again.")
  if(!is.numeric(high) || as.integer(high) != high) stop("Upper bound must be an integer. Try again.")
  if(high < low) stop("Upper bound must be strictly greater than lower bound. Try again.")
  if(low == high) stop("This game is impossible to lose. Try again.")
  invisible()
}

#R's system for checking if numbers are integers is lacking (e.g. is.integer(1) returns FALSE)
#so we need this next function.
#A better way to check for integer inputs can be found in is.interger's docs, but this is easier to read.
#Note that readline outputs the user's input as a string, hence the need for type.convert.
getValidInput <- function(requestText)
{
  guess <- type.convert(readline(requestText))
  while(!is.numeric(guess) || as.integer(guess) != guess){guess <- type.convert(readline("That wasn't an integer! Try again "))}
  as.integer(guess)
}
