bf <- function(code) {
  instructions <- strsplit(code, "")[[1]]
  tape <- c()
  visited <- c()

  pset <- function(n) {
    if (n %in% visited)
      p <<- n
    else {
      visited[length(visited)+1] <<- n
      tape[as.character(n)] <<- 0
      pset(n)
    }
  }

  bracket <- function(b1, b2, x) {
    nest <- 1
    j <- i + x
    while (nest != 0) {
      if (instructions[j] == b1)
        nest <- nest + 1
      if (instructions[j] == b2)
        nest <- nest - 1
      j <- j + x
    }
    i <<- j
  }

  pset(0)
  i <- 1
  while (i <= length(instructions)) {
    p_ <- as.character(p)
    c <- instructions[i]
    switch(c,
           ">" = pset(p + 1),
           "<" = pset(p - 1),
           "+" = tape[p_] <- tape[p_] + 1,
           "-" = tape[p_] <- tape[p_] - 1,
           "." = cat(intToUtf8(tape[p_])),
           # TODO: IMPLEMENT ","
           "[" = if (tape[p_] == 0) {
                   bracket("[", "]", 1)
                   i <- i - 1 # off by one error
                 },
           "]" = bracket("]", "[", -1))
    i <- i + 1
  }
}

bf("++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++.>+.+++++++..+++.<<++.>+++++++++++++++.>.+++.------.--------.<<+.<.")
