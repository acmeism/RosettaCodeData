# EBNF Parser in R
library(jsonlite)

EBNFParser <- function() {
  # Initialize parser state
  self <- list()

  # Instance variables
  self$src <- ""
  self$ch <- ""
  self$sdx <- 1  # R uses 1-based indexing
  self$token <- NULL
  self$err <- FALSE
  self$idents <- character(0)
  self$ididx <- integer(0)
  self$productions <- list()
  self$extras <- list()
  self$results <- c("pass", "fail")

  # Helper function to convert boolean to integer
  self$btoi <- function(b) {
    if (b) 1 else 0
  }

  # Error handling function
  self$invalid <- function(msg) {
    self$err <<- TRUE
    cat(msg, "\n")
    self$sdx <<- nchar(self$src) + 1  # set to eof
    return(-1)
  }

  # Skip whitespace characters
  self$skip_spaces <- function() {
    while (self$sdx <= nchar(self$src)) {
      self$ch <<- substr(self$src, self$sdx, self$sdx)
      if (!grepl("[ \t\r\n]", self$ch)) {
        break
      }
      self$sdx <<- self$sdx + 1
    }
  }

  # Tokenizer function
  self$get_token <- function() {
    self$skip_spaces()
    if (self$sdx > nchar(self$src)) {
      self$token <<- list(value = -1, is_sequence = FALSE)
      return()
    }

    tokstart <- self$sdx
    if (grepl("[{}()\\[\\]|=.;]", self$ch)) {
      self$sdx <<- self$sdx + 1
      self$token <<- list(value = self$ch, is_sequence = FALSE)
    } else if (self$ch %in% c('"', "'")) {
      closech <- self$ch
      tokend <- tokstart + 1
      while (tokend <= nchar(self$src) && substr(self$src, tokend, tokend) != closech) {
        tokend <- tokend + 1
      }
      if (tokend > nchar(self$src)) {
        self$token <<- list(value = self$invalid("no closing quote"), is_sequence = FALSE)
      } else {
        self$sdx <<- tokend + 1
        self$token <<- list(
          value = list("terminal", substr(self$src, tokstart + 1, tokend - 1)),
          is_sequence = TRUE
        )
      }
    } else if (grepl("[a-z]", self$ch)) {
      # Identifiers are strictly a-z only
      while (self$sdx <= nchar(self$src) && grepl("[a-z]", self$ch)) {
        self$sdx <<- self$sdx + 1
        if (self$sdx <= nchar(self$src)) {
          self$ch <<- substr(self$src, self$sdx, self$sdx)
        }
      }
      self$token <<- list(
        value = list("ident", substr(self$src, tokstart, self$sdx - 1)),
        is_sequence = TRUE
      )
    } else {
      self$token <<- list(value = self$invalid("invalid ebnf"), is_sequence = FALSE)
    }
  }

  # Match expected token
  self$match_token <- function(expected_ch) {
    if (!identical(self$token$value, expected_ch)) {
      self$token <<- list(
        value = self$invalid(paste0("invalid ebnf (", expected_ch, " expected)")),
        is_sequence = FALSE
      )
    } else {
      self$get_token()
    }
  }

  # Add identifier to symbol table
  self$add_ident <- function(ident) {
    k <- which(self$idents == ident)
    if (length(k) == 0) {
      self$idents <<- c(self$idents, ident)
      k <- length(self$idents)
      self$ididx <<- c(self$ididx, -1)
    } else {
      k <- k[1]
    }
    return(k)
  }

  # Parse factor (atomic elements)
  self$factor <- function() {
    if (self$token$is_sequence) {
      t <- self$token$value
      if (t[[1]] == "ident") {
        idx <- self$add_ident(t[[2]])
        t[[3]] <- idx
        self$token$value <<- t
      }
      res <- self$token$value
      self$get_token()
    } else if (identical(self$token$value, "[")) {
      self$get_token()
      res <- list("optional", self$expression())
      self$match_token("]")
    } else if (identical(self$token$value, "(")) {
      self$get_token()
      res <- self$expression()
      self$match_token(")")
    } else if (identical(self$token$value, "{")) {
      self$get_token()
      res <- list("repeat", self$expression())
      self$match_token("}")
    } else {
      stop("invalid token in factor() function")
    }

    if (is.list(res) && length(res) == 1) {
      return(res[[1]])
    }
    return(res)
  }

  # Parse term (sequence of factors)
  self$term <- function() {
    res <- list(self$factor())
    tokens <- list(-1, "|", ".", ";", ")", "]", "}")

    while (TRUE) {
      if (any(sapply(tokens, function(x) identical(self$token$value, x)))) {
        break
      }
      res[[length(res) + 1]] <- self$factor()
    }

    if (length(res) == 1) {
      return(res[[1]])
    }
    return(res)
  }

  # Parse expression (alternatives)
  self$expression <- function() {
    res <- list(self$term())
    if (identical(self$token$value, "|")) {
      res <- list("or", res[[1]])
      while (identical(self$token$value, "|")) {
        self$get_token()
        res[[length(res) + 1]] <- self$term()
      }
    }

    if (length(res) == 1) {
      return(res[[1]])
    }
    return(res)
  }

  # Parse production rule
  self$production <- function() {
    self$get_token()
    if (!identical(self$token$value, "}")) {
      if (identical(self$token$value, -1)) {
        return(self$invalid("invalid ebnf (missing closing })"))
      }
      if (!self$token$is_sequence) {
        return(-1)
      }

      t <- self$token$value
      if (t[[1]] != "ident") {
        return(-1)
      }

      ident <- t[[2]]
      idx <- self$add_ident(ident)
      self$get_token()
      self$match_token("=")
      if (identical(self$token$value, -1)) {
        return(-1)
      }

      self$productions[[length(self$productions) + 1]] <<- list(ident, idx, self$expression())
      self$ididx[idx] <<- length(self$productions)
    }

    return(self$token$value)
  }

  # Main parsing function
  self$parse <- function(ebnf) {
    cat("parse:\n", ebnf, " ===>\n", sep = "")
    self$err <<- FALSE
    self$src <<- ebnf
    self$sdx <<- 1
    self$idents <<- character(0)
    self$ididx <<- integer(0)
    self$productions <<- list()
    self$extras <<- list()

    self$get_token()
    if (self$token$is_sequence) {
      t <- self$token$value
      t[[1]] <- "title"
      self$extras[[length(self$extras) + 1]] <<- self$token$value
      self$get_token()
    }

    if (!identical(self$token$value, "{")) {
      return(self$invalid("invalid ebnf (missing opening {)"))
    }

    while (TRUE) {
      token_result <- self$production()
      if (identical(token_result, "}") || identical(token_result, -1)) {
        break
      }
    }

    self$get_token()
    if (self$token$is_sequence) {
      t <- self$token$value
      t[[1]] <- "comment"
      self$extras[[length(self$extras) + 1]] <<- self$token$value
      self$get_token()
    }

    if (!identical(self$token$value, -1)) {
      return(self$invalid("invalid ebnf (missing eof?)"))
    }

    if (self$err) {
      return(-1)
    }

    k <- which(self$ididx == -1)
    if (length(k) > 0) {
      return(self$invalid(paste0("invalid ebnf (undefined:", self$idents[k[1]], ")")))
    }

    self$pprint(self$productions, "productions")
    self$pprint(self$idents, "idents")
    self$pprint(self$ididx, "ididx")
    self$pprint(self$extras, "extras")
    return(1)
  }

  # Pretty print function
  self$pprint <- function(ob, header) {
    cat("\n", header, ":\n", sep = "")
    pp <- toJSON(ob, auto_unbox = TRUE)
    pp <- gsub("\\[", "{", pp)
    pp <- gsub("\\]", "}", pp)
    pp <- gsub(",", ", ", pp)
    for (i in seq_along(self$idents)) {
      pp <- gsub(paste0("\\b", i-1, "\\b"), as.character(i-1), pp)
    }
    cat(pp, "\n")
  }

  # Apply grammar rules to input
  self$applies <- function(rule) {
    was_sdx <- self$sdx  # in case of failure
    r1 <- rule[[1]]

    if (!is.character(r1)) {
      for (i in seq_along(rule)) {
        if (!self$applies(rule[[i]])) {
          self$sdx <<- was_sdx
          return(FALSE)
        }
      }
    } else if (r1 == "terminal") {
      self$skip_spaces()
      r2 <- rule[[2]]
      for (i in seq_len(nchar(r2))) {
        if (self$sdx > nchar(self$src) || substr(self$src, self$sdx, self$sdx) != substr(r2, i, i)) {
          self$sdx <<- was_sdx
          return(FALSE)
        }
        self$sdx <<- self$sdx + 1
      }
    } else if (r1 == "or") {
      for (i in 2:length(rule)) {
        if (self$applies(rule[[i]])) {
          return(TRUE)
        }
      }
      self$sdx <<- was_sdx
      return(FALSE)
    } else if (r1 == "repeat") {
      while (self$applies(rule[[2]])) {
        # continue repeating
      }
    } else if (r1 == "optional") {
      self$applies(rule[[2]])
    } else if (r1 == "ident") {
      i <- rule[[3]]
      ii <- self$ididx[i]
      if (!self$applies(self$productions[[ii]][[3]])) {
        self$sdx <<- was_sdx
        return(FALSE)
      }
    } else {
      stop("invalid rule in applies() function")
    }

    return(TRUE)
  }

  # Check if input is valid according to grammar
  self$check_valid <- function(test) {
    self$src <<- test
    self$sdx <<- 1
    res <- self$applies(self$productions[[1]][[3]])
    self$skip_spaces()
    if (self$sdx <= nchar(self$src)) {
      res <- FALSE
    }
    cat('"', test, '", ', self$results[1 + self$btoi(!res)], "\n", sep = "")
  }

  return(self)
}

# Main execution
parser <- EBNFParser()

ebnfs <- c(
  '"a" {
    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
} "z" ',

  '{
    expr = term { plus term } .
    term = factor { times factor } .
    factor = number | \'(\' expr \')\' .

    plus = "+" | "-" .
    times = "*" | "/" .

    number = digit { digit } .
    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
}',

  'a = "1"',
  '{ a = "1" ;',
  '{ hello world = "1"; }',
  '{ foo = bar . }'
)

tests <- list(
  c(
    'a1a3a4a4a5a6',
    'a1 a2a6',
    'a1 a3 a4 a6',
    'a1 a4 a5 a6',
    'a1 a2 a4 a5 a5 a6',
    'a1 a2 a4 a5 a6 a7',
    'your ad here'
  ),
  c(
    '2',
    '2*3 + 4/23 - 7',
    '(3 + 4) * 6-2+(4*(4))',
    '-2',
    '3 +',
    '(4 + 3'
  )
)

for (i in seq_along(ebnfs)) {
  if (parser$parse(ebnfs[i]) == 1) {
    cat('\ntests:\n')
    if (i <= length(tests)) {
      for (test in tests[[i]]) {
        parser$check_valid(test)
      }
    }
  }
  cat('\n')
}
