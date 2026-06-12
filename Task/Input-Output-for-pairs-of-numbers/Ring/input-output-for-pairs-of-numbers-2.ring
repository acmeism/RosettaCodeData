# Project : Input/Output for Pairs of Numbers (Alternative)

pairs = ["5", "1 2", "10 20", "5 -3", "100 2", "5 5"]
for n = 1 to len(pairs)
    nr = 0
    for p = 1 to len(pairs[n])
        if substr(pairs[n], p, 1) = " "
           pairs[n] = substr(pairs[n], " ", "+")
           nr = p
        ok
    next
    if nr > 0
       eval("ev = " + pairs[n])
       see ev + nl
    ok
next
>>>
