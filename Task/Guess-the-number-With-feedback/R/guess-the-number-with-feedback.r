GuessANumber <- function( low, high ) {
  print( sprintf("Guess a number between %d and %d until you get it right", low, high ) );
  X <- low:high;
  number <- sample( X, 1 );
  repeat {
    input <- as.numeric(readline());
    if (input > number) {
      print("Too high, try again"); }
    else if (input < number) {
      print("Too low, try again");}
    else {
      print("Correct!");
      break; }
  }
}
