from __future__ import print_function, division

def combos(sides, n):
    if not n: return [1]
    ret = [0] * (max(sides)*n + 1)
    for i,v in enumerate(combos(sides, n - 1)):
        if not v: continue
        for s in sides: ret[i + s] += v
    return ret

def winning(sides1, n1, sides2, n2):
    p1, p2 = combos(sides1, n1), combos(sides2, n2)
    win,loss,tie = 0,0,0 # 'win' is 1 beating 2
    for i,x1 in enumerate(p1):
        # using accumulated sum on p2 could save some time
        win += x1*sum(p2[:i])
        tie += x1*sum(p2[i:i+1])
        loss+= x1*sum(p2[i+1:])
    s = sum(p1)*sum(p2)
    return win/s, tie/s, loss/s

print(winning(range(1,5), 9, range(1,7), 6))
print(winning(range(1,11), 5, range(1,8), 6)) # this seem hardly fair

# mountains of dice test case
# print(winning((1, 2, 3, 5, 9), 700, (1, 2, 3, 4, 5, 6), 800))
