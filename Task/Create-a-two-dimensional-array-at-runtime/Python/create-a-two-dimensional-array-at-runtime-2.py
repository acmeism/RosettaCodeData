myarray = {(w,h): 0 for w in range(width) for h in range(height)}
# or, in pre 2.7 versions of Python: myarray = dict(((w,h), 0) for w in range(width) for h in range(height))
myarray[(0,0)] = 3.5
print myarray[(0,0)]
