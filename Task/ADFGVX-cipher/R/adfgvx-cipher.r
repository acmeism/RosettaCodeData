# The ADFGVX cipher.
# See also eg. https://www.nku.edu/~christensen/092hnr304%20ADFGVX.pdf

# ADFGVX class using R6
library(R6)

ADFGVX <- R6Class("ADFGVX",
  public = list(
    polybius = NULL,
    pdim = NULL,
    key = NULL,
    keylen = NULL,
    alphabet = NULL,
    encode = NULL,
    decode = NULL,

    # Constructor
    initialize = function(s, k, alph = "ADFGVX") {
      self$polybius <- toupper(strsplit(s, "")[[1]])
      self$pdim <- floor(sqrt(length(self$polybius)))
      self$alphabet <- toupper(strsplit(alph, "")[[1]])

      # Create encoding dictionary
      self$encode <- list()
      for (i in 1:self$pdim) {
        for (j in 1:self$pdim) {
          char <- self$polybius[(i - 1) * self$pdim + j]
          self$encode[[char]] <- c(self$alphabet[i], self$alphabet[j])
        }
      }

      # Create decoding dictionary
      self$decode <- list()
      for (char in names(self$encode)) {
        key_str <- paste(self$encode[[char]], collapse = "")
        self$decode[[key_str]] <- char
      }

      stopifnot(self$pdim^2 == length(self$polybius) &&
                self$pdim == length(self$alphabet))

      self$key <- toupper(strsplit(k, "")[[1]])
      self$keylen <- length(self$key)
    },

    # Encrypt with the ADFGVX cipher
    encrypt = function(s) {
      chars_upper <- toupper(strsplit(s, "")[[1]])
      chars_filtered <- chars_upper[chars_upper %in% self$polybius]

      # Encode characters
      chars <- unlist(lapply(chars_filtered, function(c) self$encode[[c]]))

      # Create column vectors
      colvecs <- list()
      for (i in 1:self$keylen) {
        indices <- seq(i, length(chars), by = self$keylen)
        colvecs[[self$key[i]]] <- chars[indices]
      }

      # Sort by key
      sorted_names <- sort(names(colvecs))
      result <- unlist(lapply(sorted_names, function(name) colvecs[[name]]))

      return(paste(result, collapse = ""))
    },

    # Decrypt with the ADFGVX cipher
    decrypt = function(s) {
      chars <- toupper(strsplit(s, "")[[1]])
      chars <- chars[chars %in% self$alphabet]

      sortedkey <- sort(self$key)
      order <- sapply(sortedkey, function(ch) which(self$key == ch)[1])
      originalorder <- sapply(self$key, function(ch) which(sortedkey == ch)[1])

      # Calculate strides (column lengths)
      div_result <- length(chars) %/% self$keylen
      rem_result <- length(chars) %% self$keylen
      strides <- sapply(order, function(i) {
        div_result + ifelse(rem_result >= i, 1, 0)
      })

      # Calculate starts and ends of columns
      starts <- c(1, cumsum(strides[-length(strides)]) + 1)
      ends <- starts + strides - 1

      # Get reordered columns
      cols <- lapply(originalorder, function(i) {
        chars[starts[i]:ends[i]]
      })

      # Recover the rows
      nrows <- (length(chars) - 1) %/% self$keylen + 1
      pairs <- c()
      for (i in 1:nrows) {
        for (j in 1:self$keylen) {
          if ((i - 1) * self$keylen + j > length(chars)) break
          pairs <- c(pairs, cols[[j]][i])
        }
      }

      # Decode pairs
      result <- c()
      for (i in seq(1, length(pairs) - 1, by = 2)) {
        pair_str <- paste(pairs[i:(i+1)], collapse = "")
        result <- c(result, self$decode[[pair_str]])
      }

      return(paste(result, collapse = ""))
    }
  )
)

# Main execution
set.seed(123)  # For reproducibility
POLYBIUS <- paste(sample(strsplit("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", "")[[1]]),
                  collapse = "")

# Get dictionary words - try multiple sources
get_valid_key <- function() {
  # Try to read unixdict.txt if it exists
  if (file.exists("unixdict.txt")) {
    dict_words <- readLines("unixdict.txt")
  } else {
    # Use sample words if file doesn't exist
    dict_words <- c("absolutes", "abruption", "abundance", "abysmally",
                    "acrobatic", "algorithm", "ambiguity", "amplitude",
                    "ancestory", "archetype", "asynchron", "auctioned",
                    "backbone", "backfired", "backlights", "bandwidth",
                    "benchmark", "biography", "birthplace", "blasphemy",
                    "boulevard", "bricklaying", "broadcast", "butchering",
                    "cauterize", "chemicals", "chromatic", "clipboard",
                    "completing", "conjugate", "copyright", "daughters",
                    "debuggers", "delimiters", "demograph", "dialyzing",
                    "dictionary", "education", "equations", "factorize",
                    "geography", "goshdarn", "graciously", "graphed",
                    "hampshire", "imploding", "indexable", "jeculates",
                    "keyboards", "labyrinth", "livestock", "logarithm",
                    "machinery", "molecules", "nightmare", "obscurity",
                    "particles", "quizboard", "racehorst", "reduction",
                    "savepoint", "sectional", "shipyard", "splatting",
                    "substance", "technology", "ulceration", "vineyard",
                    "warehouse", "workplace", "xanthopsy", "yachtsmen")
  }

  # Filter for 9-letter words with unique characters
  valid_words <- dict_words[sapply(dict_words, function(w) {
    n <- nchar(w)
    n == 9 && length(unique(strsplit(w, "")[[1]])) == n
  })]

  if (length(valid_words) == 0) {
    stop("No valid 9-letter words with unique characters found")
  }

  return(toupper(sample(valid_words, 1)))
}

KEY <- get_valid_key()

# Create cipher and encrypt/decrypt
SECRETS <- ADFGVX$new(POLYBIUS, KEY)
message <- "ATTACKAT1200AM"

cat("Polybius:", POLYBIUS, ", Key:", KEY, "\n")
cat("Message:", message, "\n")

encoded <- SECRETS$encrypt(message)
decoded <- SECRETS$decrypt(encoded)

cat("Encoded:", encoded, "\n")
cat("Decoded:", decoded, "\n")
