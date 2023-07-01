bullsAndCowsPlayer <- function()
{
  guesses <- 1234:9876
  #The next line is terrible code, but it's the most R way to convert a set of 4-digit numbers to their 4 digits.
  guessDigits <- t(sapply(strsplit(as.character(guesses), ""), as.integer))
  validGuesses <- guessDigits[apply(guessDigits, 1, function(x) length(unique(x)) == 4 && all(x != 0)), ]
  repeat
  {
    remainingCasesCount <- nrow(validGuesses)
    cat("Possibilities remaining:", remainingCasesCount)#Not required, but excellent when debugging.
    guess <- validGuesses[sample(remainingCasesCount, 1), ]
    guessAsOneNumber <- as.integer(paste(guess, collapse = ""))
    bulls <- as.integer(readline(paste0("My guess is ", guessAsOneNumber, ". Bull score? [0-4] ")))
    if(bulls == 4) return(paste0("Your number is ", guessAsOneNumber, ". I win!"))
    cows <- as.integer(readline("Cow score? [0-4] "))
    #If our guess scores y bulls, then only numbers containing exactly y digits with the same value and position (y "pseudoBulls") as in our guess can be correct.
    #Accounting for the positions of cows not being fixed, the same argument also applies for them.
    #The following lines make us only keep the numbers that have the right pseudoBulls and "pseudoCows" scores, albeit without the need for a pseudoCows function.
    #We also use pseudoBulls != 4 to remove our most recent guess, because we know that it cannot be correct.
    #Finally, the drop=FALSE flag is needed to stop R converting validGuesses to a vector when there is only one guess left.
    pseudoBulls <- function(x) sum(x == guess)
    isGuessValid <- function(x) pseudoBulls(x) == bulls && sum(x %in% guess) - pseudoBulls(x) == cows && pseudoBulls(x) != 4
    validGuesses <- validGuesses[apply(validGuesses, 1, isGuessValid), , drop = FALSE]
    if(nrow(validGuesses) == 0) return("Error: Scoring problem?")
  }
}
bullsAndCowsPlayer()
