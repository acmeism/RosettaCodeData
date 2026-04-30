#' Parses an infix expression string into Reverse Polish Notation (RPN).
#'
#' This function implements the Shunting-yard algorithm to convert a space-separated
#' infix mathematical expression into a space-separated RPN expression.
#'
#' @param s A string containing the infix expression, with tokens separated by spaces.
#' @return A character vector representing the expression in RPN.
#' @examples
#' teststring <- "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
#' rpn_result <- parseinfix2rpn(teststring)
#' cat("\nResult:", teststring, "becomes", paste(rpn_result, collapse = " "), "\n")
parseinfix2rpn <- function(s) {
  # Initialize output queue and operator stack as character vectors
  outputq <- c()
  opstack <- c()

  # Split the input string into tokens
  infix <- strsplit(s, " ")[[1]]

  # Define operator precedence. Higher number means higher precedence.
  # This mirrors Julia's precedence for the operators used.
  precedence <- list(
    `+` = 10, `-` = 10,
    `*` = 20, `/` = 20,
    `^` = 30
  )

  for (tok in infix) {
    # Check if the token is a number (integer or decimal)
    if (!is.na(as.numeric(tok))) {
      outputq <- c(outputq, tok)
    } else if (tok == "(") {
      opstack <- c(opstack, tok)
    } else if (tok == ")") {
      # Pop operators from the stack to the output until a "(" is found
      while (length(opstack) > 0) {
        op <- opstack[length(opstack)]
        opstack <- opstack[-length(opstack)]
        if (op == "(") {
          break # Discard the "(" and stop
        }
        outputq <- c(outputq, op)
      }
    } else { # Operator
      # While there is an operator at the top of the stack with higher precedence,
      # or with the same precedence and the current operator is not right-associative (^),
      # pop it to the output queue.
      while (length(opstack) > 0) {
        top_op <- opstack[length(opstack)]

        # Stop if the top of the stack is a parenthesis
        if (top_op == "(") {
          break
        }

        # Compare precedence
        if (precedence[[top_op]] > precedence[[tok]] ||
            (precedence[[top_op]] == precedence[[tok]] && tok != "^")) {
          # Pop from opstack and push to outputq
          opstack <- opstack[-length(opstack)]
          outputq <- c(outputq, top_op)
        } else {
          # The operator on the stack has lower precedence, so stop.
          break
        }
      }
      # Push the current operator onto the stack
      opstack <- c(opstack, tok)
    }

    # Debug print statement (equivalent to Julia's println)
    cat("The working output stack is", paste(outputq, collapse = " "), "\n")
  }

  # After the loop, pop any remaining operators from the stack to the output
  while (length(opstack) > 0) {
    op <- opstack[length(opstack)]
    opstack <- opstack[-length(opstack)]
    if (op == "(") {
      stop("mismatched parentheses")
    }
    outputq <- c(outputq, op)
  }

  return(outputq)
}

# --- Test the function ---
teststring <- "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
rpn_result <- parseinfix2rpn(teststring)
cat("\nResult:", teststring, "becomes", paste(rpn_result, collapse = " "), "\n")
