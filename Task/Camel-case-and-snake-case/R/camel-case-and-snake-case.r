library(stringr)

test_strings <- c("snakeCase", "snake_case", "variable_10_case", "variable10Case", "ɛrgo rE tHis",
                  "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  ")

#Simple functions
snake2camel <- function(s){
  boundaries <- str_extract_all(s, "_+[^_]", simplify=TRUE)
  boundaries <- str_replace_all(boundaries, "_", "")
  for(b in boundaries){
    s <- str_replace_all(s, str_c("_+",b), str_to_upper(b))
  }
  return(s)
}

writeLines(c("Snake to camel case:", sapply(test_strings, camel2snake)))

camel2snake <- function(s){
  boundaries <- str_extract_all(s, "[A-Z]", simplify=TRUE)
  for(b in boundaries){
    s <- str_replace_all(s, b, str_c("_", str_to_lower(b)))
  }
  return(s)
}

writeLines(c("Camel to snake case:", sapply(test_strings, camel2snake)))

#More general functions
any2camel <- function(s){
  #strip leading and trailing whitespace
  s <- str_replace_all(s, "^[\\h]+|[\\h]+$", "")
  #Deal with specified separators
  boundaries <- str_extract_all(s, "[ _-]+[^ _-]", simplify=TRUE)
  boundaries <- str_replace_all(boundaries, "[ _-]", "")
  for(b in boundaries){
    s <- str_replace_all(s, str_c("[ _-]+", b), str_to_upper(b))
  }
  return(s)
}

writeLines(c("Any separator to camel case:", sapply(test_strings, any2camel)))

any2snake <- function(s){
  s <- str_replace_all(s, "^[\\h]+|[\\h]+$", "")
  boundaries_camel <- str_extract_all(s, "[A-Z]", simplify=TRUE)
  boundaries_other <- str_extract_all(s, "[ -]+", simplify=TRUE)
  for(b in boundaries_camel){
    s <- str_replace_all(s, b, str_c("_", str_to_lower(b)))
  }
  for(b in boundaries_other){
    s <- str_replace_all(s, b, "_")
  }
  return(s)
}

writeLines(c("Any separator to snake case:", sapply(test_strings, any2snake)))
