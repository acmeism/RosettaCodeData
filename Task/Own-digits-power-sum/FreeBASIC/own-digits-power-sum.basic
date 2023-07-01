dim as uinteger N, curr, temp, dig, sum

for N = 3 to 9
    for curr = 10^(N-1) to 10^N-1
        sum = 0
        temp = curr
        do
            dig = temp mod 10
            temp = temp \ 10
            sum += dig ^ N
        loop until temp = 0
        if sum = curr then print curr
    next curr
next N
