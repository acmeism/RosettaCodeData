;- based on Lua code ;-)

sum-of-divisors: func[n /local sum][
    sum: 1
    ; using `to-integer` for compatibility with Rebol2
    for d 2 (to-integer square-root n) 1 [
        if 0 = remainder n d [ sum: n / d + sum + d ]
    ]
    sum
]

for n 2 20000 1 [
    if n < m: sum-of-divisors n [
        if n = sum-of-divisors m [ print [n tab m] ]
    ]
]
