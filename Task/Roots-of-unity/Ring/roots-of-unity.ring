decimals(4)
for n = 2 to 5
    see string(n) + " : "
    for root = 0 to n-1
        real = cos(2*3.14 * root / n)
        imag = sin(2*3.14 * root / n)
        see "" + real + " " + imag + "i"
        if root != n-1 see ", " ok
    next
    see nl
next
