cusip_checkdigit <- function(s) {
  chars <- strsplit(s, "") |> unlist()
  1:8 |> sapply(
    function(n) {
      char <- chars[n]
      res <- (1 + (n%%2 == 0)) * {
        if (grepl("[0-9]", char)) as.numeric(char)
        else if (grepl("[A-Z]", char)) 9 + which(LETTERS == char)
        else switch(char, "*" = 36, "@" = 37, "#" = 38)
      }
      res%/%10 + res%%10
    }
  ) |> sum() |> (function(x) (10 - (x%%10)) %% 10)()
}

cusip_isvalid <- function(s) {
  if (nchar(s) != 9) {
    stop("CUSIP must have exactly 9 characters")
  }
  checksum <- cusip_checkdigit(s) |> as.character()
  ifelse(endsWith(s, checksum), "Valid CUSIP", "Invalid CUSIP")
}

test_cusips <- c(
  "037833100", "17275R102", "38259P508", "594918104", "68389X106", "68389X105"
)
sapply(test_cusips, cusip_isvalid) |> print(quote = FALSE)
