x <- "global x"
f <- function() {
  cat("Lexically enclosed x: ", x,"\n")
  cat("Lexically enclosed x: ", evalq(x, parent.env(sys.frame())),"\n")
  cat("Dynamically enclosed x: ", evalq(x, parent.frame()),"\n")
}

local({
  x <- "local x"
  f()
})
