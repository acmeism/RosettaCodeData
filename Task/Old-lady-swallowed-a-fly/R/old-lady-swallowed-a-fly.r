animals = list(
  c("fly", "I don't know why she swallowed a fly, perhaps she'll die."),
  c("spider", "It wiggled and jiggled and tickled inside her."),
  c("bird", "How absurd, to swallow a bird."),
  c("cat", "Imagine that, she swallowed a cat."),
  c("dog", "What a hog, to swallow a dog."),
  c("goat", "She just opened her throat and swallowed a goat."),
  c("cow", "I don't know how she swallowed a cow."),
  c("horse", "She's dead, of course.")
)

oldladyalive <- TRUE
oldladysnack <- 1

while(oldladyalive == TRUE) {
  nextmeal <- animals[[oldladysnack]][1]
  nextcomment <- animals[[oldladysnack]][2]
  print(sprintf("There was an old lady who swallowed a %s. %s",nextmeal,nextcomment))

  if(oldladysnack == 8){
    oldladyalive <- FALSE # she ate a horse :(
  } else if(oldladysnack > 1) {
    for(i in oldladysnack:2) {
      print(sprintf("    She swallowed the %s to catch the %s",
              animals[[i]][1], #e.g. spider (to catch the...
              animals[[i-1]][1])) # fly)

    }
    print(animals[[1]][2])
  }
  oldladysnack <- oldladysnack + 1
}
