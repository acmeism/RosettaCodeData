# based on Rot-13 solution: http://rosettacode.org/wiki/Rot-13#R
ceasar <- function(x, key)
{
  # if key is negative, wrap to be positive
  if (key < 0) {
    key <- 26 + key
  }

  old <- paste(letters, LETTERS, collapse="", sep="")
  new <- paste(substr(old, key * 2 + 1, 52), substr(old, 1, key * 2), sep="")
  chartr(old, new, x)
}

# simple examples from description
print(ceasar("hi",2))
print(ceasar("hi",20))

# more advanced example
key <- 3
plaintext <- "The five boxing wizards jump quickly."
cyphertext <- ceasar(plaintext, key)
decrypted <- ceasar(cyphertext, -key)

print(paste("    Plain Text: ", plaintext, sep=""))
print(paste("   Cypher Text: ", cyphertext, sep=""))
print(paste("Decrypted Text: ", decrypted, sep=""))
