# Project : Input/Output for Pairs of Numbers

pairs = ["5", "1 2", "10 20", "-3 5", "100 2", "5 5"]
for n = 1 to len(pairs)
    nr = 0
    for p = 1 to len(pairs[n])
        if substr(pairs[n], p, 1) = " "
           nr = p
        ok
    next
    if nr > 0
       n1 = number(left(pairs[n], nr - 1))
       n2 = number(right(pairs[n], len(pairs[n]) - nr + 1))
       n3 = n1 + n2
       see n3 + nl
    ok
next
