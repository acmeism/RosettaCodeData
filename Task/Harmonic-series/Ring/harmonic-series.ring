decimals(12)
sum = 0
nNew = 1
limit = 13000
Harmonic = []


for n = 1 to limit
    sum += 1/n
    add(Harmonic,[n,sum])
next

see "The first twenty harmonic numbers are:" + nl
for n = 1 to 20
    see "" + Harmonic[n][1] + " -> " + Harmonic[n][2] + nl
next
see nl

for m = 1 to 10
    for n = nNew to len(Harmonic)
        if Harmonic[n][2] > m
           see "The first harmonic number greater than "
           see "" + m + " is " + Harmonic[n][2] + ", at position " + n + nl
           nNew = n
           exit
        ok
    next
next
