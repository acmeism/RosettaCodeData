## Nim game
##

tokens <- 12

while(tokens > 0) {
  print(paste("Tokens remaining:",tokens))
  playertaken <- 0
  while(playertaken == 0) {
    playeropts <- c(1:min(c(tokens,3)))
    playertaken <- menu(playeropts, title = "Your go, how many tokens will you take? ")
    tokens <- tokens - playertaken
    if(tokens == 0) {print("Well done you won, that shouldn't be possible!")}
  }
  cputaken <- 4 - playertaken
  tokens <- tokens - cputaken
  print(paste("I take",cputaken,"tokens,",tokens,"remain"))
  if(tokens == 0) {print("I win!")}

}
