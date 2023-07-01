? "working..."
limit = 100
? "Largest proper divisor up to " + limit + " are:"
see " 1 "
col = 1

for n = 2 to limit
    for m = 1 to n >> 1
        if n % m = 0 div = m ok
    next
    if div < 10 see " " ok
    see "" + div + " "
    if col++ % 10 = 0 ? "" ok
next
? "done..."
