library(stringr)

s <- " World!"
str_sub(s, 0, 0) <- "Hello"
print(s)
