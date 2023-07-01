x <-c(
  "apples, pears # and bananas",       # the requested hash test
  "apples, pears ; and bananas",       # the requested semicolon test
  "apples, pears   and bananas",       # without a comment
  " apples, pears # and bananas"       # with preceding spaces
)
strip_comments(x)
