Ellie = EllipticCurve(RR,[0,7]) # RR = field of real numbers

# a point (x,y) on Ellie, given y
def point ( y) :
    x = var('x')
    x = (y^2 - 7 - x^3).roots(x,ring=RR,multiplicities = False)[0]
    P = Ellie([x,y])
    return P

print(Ellie)
P = point(1)
print('P',P)
Q = point(2)
print('Q',Q)
S = P+Q
print('S = P + Q',S)
print('P+Q-S', P+Q-S)
print('P*12345' ,P*12345)
