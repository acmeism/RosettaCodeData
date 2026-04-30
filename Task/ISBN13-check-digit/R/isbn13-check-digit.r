isbncheck <- function(str) {
  # Remove non-digit characters
  digits <- gsub("\\D", "", str)

  # Split into individual characters and convert to numeric
  digit_vec <- as.numeric(strsplit(digits, "")[[1]])

  # Calculate weighted sum
  weighted_sum <- sum(sapply(seq_along(digit_vec), function(i) {
    if (i %% 2 == 0) {
      3 * digit_vec[i]
    } else {
      digit_vec[i]
    }
  }))

  # Check if divisible by 10
  return(weighted_sum %% 10 == 0)
}

# Test codes
testing_codes <- c("978-0596528126", "978-0596528120",
                   "978-1788399081", "978-1788399083")

for (code in testing_codes) {
  result <- ifelse(isbncheck(code), "good", "bad")
  cat(code, ": ", result, "\n", sep = "")
}
