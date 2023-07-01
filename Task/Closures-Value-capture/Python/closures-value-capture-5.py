funcs = [(lambda i: lambda: i)(i * i) for i in range(10)]
print funcs[3]() # prints 9
