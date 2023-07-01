def MagicSquareDoublyEven(order):
    sq = [range(1+n*order,order + (n*order)+1) for n in range(order) ]
    n1 = order/4
    for r in range(n1):
        r1 = sq[r][n1:-n1]
        r2 = sq[order -r - 1][n1:-n1]
        r1.reverse()
        r2.reverse()
        sq[r][n1:-n1] = r2
        sq[order -r - 1][n1:-n1] = r1
    for r in range(n1, order-n1):
        r1 = sq[r][:n1]
        r2 = sq[order -r - 1][order-n1:]
        r1.reverse()
        r2.reverse()
        sq[r][:n1] = r2
        sq[order -r - 1][order-n1:] = r1
    return sq

def printsq(s):
    n = len(s)
    bl = len(str(n**2))+1
    for i in range(n):
        print ''.join( [ ("%"+str(bl)+"s")%(str(x)) for x in s[i]] )
    print "\nMagic constant = %d"%sum(s[0])

printsq(MagicSquareDoublyEven(8))
