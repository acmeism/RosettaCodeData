diversityStats <- function(trueValue, estimates)
{
  collectivePrediction <- mean(estimates)
  data.frame("True Value" = trueValue,
             as.list(setNames(estimates, paste("Guess", seq_along(estimates)))), #Guesses, each with a title and column.
             "Average Error" = mean((trueValue - estimates)^2),
             "Crowd Error" = (trueValue - collectivePrediction)^2,
             "Prediction Diversity" = mean((estimates - collectivePrediction)^2))
}
diversityStats(49, c(48, 47, 51))
diversityStats(49, c(48, 47, 51, 42))
