rpn <- function(s) {
  stack <- list()
  ops <- strsplit(s, " ")[[1]]

  for (op in ops) {
    if (op %in% c("+", "-", "*", "/", "^")) {
      arg2 <- stack[[length(stack)]]
      arg1 <- stack[[length(stack) - 1]]
      stack <- stack[-c(length(stack), length(stack) - 1)]

      if (op == "+") {
        res <- as.numeric(arg1) + as.numeric(arg2)
      } else if (op == "-") {
        res <- as.numeric(arg1) - as.numeric(arg2)
      } else if (op == "*") {
        res <- as.numeric(arg1) * as.numeric(arg2)
      } else if (op == "/") {
        res <- as.numeric(arg1) / as.numeric(arg2)
      } else if (op == "^") {
        res <- as.numeric(arg1) ^ as.numeric(arg2)
      }

      stack <- c(stack, res)
    } else {
      stack <- c(stack, as.numeric(op))
    }
    cat(op, ": ", paste(stack, collapse = ", "), "\n", sep = "")
  }

  if (length(stack) != 1) {
    stop(paste("invalid RPN expression:", s))
  }
  return(stack[[1]])
}

rpn("3 4 2 * 1 5 - 2 3 ^ ^ / +")
