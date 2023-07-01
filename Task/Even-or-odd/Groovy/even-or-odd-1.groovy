def isOdd = { int i -> (i & 1) as boolean }
def isEven = {int i -> ! isOdd(i) }
