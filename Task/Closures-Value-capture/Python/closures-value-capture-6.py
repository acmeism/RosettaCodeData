funcs = map(lambda i: lambda: i * i, range(10))
print funcs[3]() # prints 9
