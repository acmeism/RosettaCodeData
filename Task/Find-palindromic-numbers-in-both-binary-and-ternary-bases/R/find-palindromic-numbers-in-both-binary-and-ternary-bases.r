require(stringi)

base2 <- function(x){
  y <- integer(0)
  while(x >= 2){
    r <- x %% 2
    x <- x %/% 2
    y <- c(r, y)
  }
  y <- c(x, y)
  gsub(", ", "", toString(y))
}

base3 <- function(x){
  y <- integer(0)
  while(x >= 3){
    r <- x %% 3
    x <- x %/% 3
    y <- c(r, y)
  }
  y <- c(x, y)
  gsub(", ", "", toString(y))
}

# note: no check if input is legitimate base 3 number
base_3_to_base_10 <- function(base_3_number) {
  place <- 0
  multiplier <- 1
  base_10_total <- 0
  base_3_number_as_list <-  rev(number_to_list(base_3_number))
  for (one_number in base_3_number_as_list) {
    base_10_total <- base_10_total + (one_number * multiplier)
    place <- place + 1
    multiplier <- 3 ^ place
  }
  return(base_10_total)
}

number_to_list <- function(input_number){
  string_number <- toString(input_number)
  list_of_strings <- strsplit(string_number, NULL)
  integer_list <- list()
  for (one_string in list_of_strings) {
    one_integer <- as.integer(one_string)
    integer_list <- append(one_integer, integer_list)
  }
  return(integer_list)
}

is_palindrome <- function(string) {
  backwards <- stri_reverse(string)
  identical(backwards, string)
}

base_3_to_base_2 <- function(base_3_number) {
  base_10_number <- base_3_to_base_10(base_3_number)
  base_2_number_string <- base2(base_10_number)
  return(base_2_number_string)
}

list_first_2 <- function() {
  cat(0, 0, 0, "\n")
  cat(1, 1, 1, "\n")
}

palindromes_in_base_2_and_base_3 <- function(number) {
  list_first_2()
  number <- number - 2
  count <- 1
  partial_base_number <- 1
  while (count <= number) {
    partial_base_3 <- base3(partial_base_number)
    full_base_3_string <- paste0 (partial_base_3, "1", stri_reverse (as.character(partial_base_3)))
    base2_number <- base_3_to_base_2(full_base_3_string)
    if (is_palindrome(base2_number)) {
      base10_number <- base_3_to_base_10(full_base_3_string)
      cat(base10_number, base2_number, full_base_3_string, "\n")
      count <- count + 1
    }
    partial_base_number <- partial_base_number + 1
  }
}
