def mySumSquare(n):
    return reduce(lambda x,y : x + y, map(lambda x : x*x, range(n+1)))
