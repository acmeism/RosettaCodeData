twenty.four <- function(operators=c("+", "-", "*", "/", "("),
                        selector=function() sample(1:9, 4, replace=TRUE),
                        arguments=selector(),
                        goal=24) {
  newdigits <- function() {
    arguments <<- selector()
    cat("New digits:", paste(arguments, collapse=", "), "\n")
  }
  help <- function() cat("Make", goal,
      "out of the numbers",paste(arguments, collapse=", "),
      "and the operators",paste(operators, collapse=", "), ".",
      "\nEnter 'q' to quit, '!' to select new digits,",
      "or '?' to repeat this message.\n")
  help()
  repeat {
    switch(input <- readline(prompt="> "),
           q={ cat("Goodbye!\n"); break },
           `?`=help(),
           `!`=newdigits(),
           tryCatch({
             expr <- parse(text=input, n=1)[[1]]
             check.call(expr, operators, arguments)
             result <- eval(expr)
             if (isTRUE(all.equal(result, goal))) {
               cat("Correct!\n")
               newdigits()
             } else {
               cat("Evaluated to", result, "( goal", goal, ")\n")
             }
           },error=function(e) cat(e$message, "\n")))
  }
}

check.call <- function(expr, operators, arguments) {
  unexpr <- function(x) {
    if (is.call(x))
      unexpr(as.list(x))
    else if (is.list(x))
      lapply(x,unexpr)
    else x
  }
  leaves <- unlist(unexpr(expr))
  if (any(disallowed <-
          !leaves %in% c(lapply(operators, as.name),
                         as.list(arguments)))) {
    stop("'", paste(sapply(leaves[disallowed], as.character),
                    collapse=", "),
         "' not allowed. ")
  }
  numbers.used <- unlist(leaves[sapply(leaves, mode) == 'numeric'])

  if (! isTRUE(all.equal(sort(numbers.used), sort(arguments))))
   stop("Must use each number once.")
}
