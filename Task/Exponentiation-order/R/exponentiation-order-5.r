print(matrix(sapply(inputs, eval), dimnames = list(inputs, "Outputs")))
print(data.frame(Inputs = sapply(inputs, deparse), Outputs = sapply(inputs, eval))))
