Red [
    Title: "Find squares n where n+1 is prime and n < 1000"
    Author: "hinjolicious"
    Resources: "Red Sensei"
]

; Simple prime check function
prime?: func [n [integer!] /local i][
    if n < 2 [return false]
    if n = 2 [return true]
    if even? n [return false]
    i: 3
    while [i * i <= n][
        if zero? n % i [return false]
        i: i + 2
    ]
    true
]

; Find squares where n+1 is prime
results: collect [
    i: 1
    while [(n: i * i) < 1000][
        if prime? n + 1 [keep n]
        i: i + 1
    ]
]

print ["Squares n where n+1 is prime and n < 1000:"]
print results
