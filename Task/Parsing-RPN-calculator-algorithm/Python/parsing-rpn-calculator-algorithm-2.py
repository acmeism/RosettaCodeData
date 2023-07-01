a=[]
b={'+': lambda x,y: y+x, '-': lambda x,y: y-x, '*': lambda x,y: y*x,'/': lambda x,y:y/x,'^': lambda x,y:y**x}
for c in '3 4 2 * 1 5 - 2 3 ^ ^ / +'.split():
    if c in b: a.append(b[c](a.pop(),a.pop()))
    else: a.append(float(c))
    print c, a
