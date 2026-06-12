? "working..."
hi = 7654321
for z in ['1', '0']
    see "The largest " + z + "..7 pandigital prime is "
    st = clock()
    for n = hi to 0 step -18
        strn = string(n)
        pandig = true
        for i in z:'7'
            if substr(strn, i) = 0
                pandig = 0
                exit
            ok
        next
        if pandig and isprime(n)
            et = clock()
            ? "" + n + " " + (et - st) / clockspersecond() * 1000 + " ms"
            exit
        ok
    next
    hi = hi * 10 - 9
next
put "done..."

func isprime(n)
    if n % 3 = 0 return 0 ok
    i = 5
    while i * i < n
        if n % i = 0 return 0 ok i += 2
        if n % i = 0 return 0 ok i += 4
    end
    return 1
