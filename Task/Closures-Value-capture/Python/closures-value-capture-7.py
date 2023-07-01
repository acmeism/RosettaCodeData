funcs=[eval("lambda:%s"%i**2)for i in range(10)]
print funcs[3]() # prints 9
