s <- "Hello World!"
system("R CMD SHLIB rtask.c")
dyn.load("rtask.dll")
#Output from .C() is always a list, so take only the first element from it
result <- .C("test", s)[[1]]
print(result)
