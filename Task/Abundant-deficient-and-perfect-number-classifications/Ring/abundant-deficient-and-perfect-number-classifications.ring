n = 30
perfect(n)

func perfect n
for i = 1 to n
    sum = 0
    for j = 1 to i - 1
        if i % j = 0 sum = sum + j ok
    next
    see i
    if sum = i see " is a perfect number" + nl
    but sum < i see " is a deficient number" + nl
    else see " is a abundant number" + nl ok
next
