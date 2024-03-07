# Function to calculate Padovan sequence iteratively
padovan_sequence <- function(n) {
  recurrences <- numeric(n)
  recurrences[1:3] <- c(1, 1, 1)
  if (n > 3) {
    for (i in 4:n) {
      recurrences[i] <- recurrences[i-2] + recurrences[i-3]
    }
  }
  recurrences
}

# Function to calculate Padovan floor
padovan_floor <- function(aN) {
  PP <- 1.324717957244746025960908854
  SS <- 1.0453567932525329623
  floor((PP^(aN - 1)) / SS + 0.5)
}

# Function to create L-system
create_l_system<- function() {
  words <- c("A")
  text <- "A"

  while (length(words) < 32) {
    text <- strsplit(text, "")[[1]] # Split the string into a list of characters
    text <- sapply(text, function(char) {
      if (char == "A") {
        return("B")
      } else if (char == "B") {
        return("C")
      } else if (char == "C") {
        return("AB")
      }
    })
    text <- paste(text, collapse = "") # Collapse the list back into a single string
    words <- c(words, text) # Append the new word to the list
  }

  words
}


# Main script
num_terms <- 64
padovan_seq <- padovan_sequence(num_terms)
floors <- sapply(0:(num_terms-1), padovan_floor)

cat("The first 20 terms of the Padovan sequence:\n")
cat(padovan_seq[1:20], sep=" ", end="\n")
cat("\n")

cat("Recurrence and floor functions agree for first 64 terms?", all(padovan_seq == floors), "\n\n")

words <- create_l_system()

cat("The first 10 terms of the L-system:\n")
cat(words[1:10], sep=" ", end="\n")
cat("\n")

cat("Length of first 32 terms produced from the L-system match Padovan sequence? ")
word_lengths <- sapply(words, nchar)
cat(all(word_lengths[1:32] == padovan_seq[1:32]))
