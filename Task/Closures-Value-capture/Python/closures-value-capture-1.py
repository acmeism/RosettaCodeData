funcs = []
for i in range(10):
    funcs.append(lambda: i * i)
print funcs[3]() # prints 81
