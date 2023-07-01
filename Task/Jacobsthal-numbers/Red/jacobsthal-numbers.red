Red ["Jacobsthal numbers"]

jacobsthal: function [n] [to-integer (2 ** n - (-1 ** n) / 3)]

lucas: function [n] [2 ** n + (-1 ** n)]

oblong: function [n] [
    first split mold multiply to-float jacobsthal n to-float jacobsthal n + 1 #"."   ; work around integer overflow
]

prime?: function [
    "Returns true if the input is a prime number"
    n [number!] "An integer to check for primality"
][
    if 2 = n [return true]
    if any [1 = n even? n] [return false]
    limit: sqrt n
    candidate: 3
    while [candidate < limit][
        if n % candidate = 0 [return false]
        candidate: candidate + 2
    ]
    true
]

show: function [n fn][
    cols: length? mold fn n
    repeat i n [
        prin [pad fn subtract i 1 cols]
        if i % 5 = 0 [prin newline]
    ]
    prin newline
]

print "First 30 Jacobsthal numbers:"
show 30 :jacobsthal

print "First 30 Jacobsthal-Lucas numbers:"
show 30 :lucas

print "First 20 Jacobsthal oblong numbers:"
show 20 :oblong

print "First 10 Jacobsthal primes:"
primes: n: 0
while [primes < 10][
    if prime? jacobsthal n [
        print jacobsthal n
        primes: primes + 1
    ]
    n: n + 1
]
