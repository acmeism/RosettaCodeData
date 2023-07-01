Red []
inc: func ['v] [set v 1 + get v]    ;; shortcut function for n: n + 1

n: 0  found: 0 max_div: 0
print "the first 20 anti-primes are:"
while  [ inc n] [
 nDiv: 1      ;; count n / n extra
 if n > 1 [ repeat div n / 2 [ if n % div = 0  [inc nDiv] ] ]
 if nDiv > max_div [
    max_div: nDiv
    prin [n ""]
    if 20 <= inc found [halt]
 ]
]
