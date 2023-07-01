X <- "global x"
f <- function() {
  x <- "local x"
  print(x) #"local x"
}
f()                          #prints "local x"
print(x)                     #prints "global x"
