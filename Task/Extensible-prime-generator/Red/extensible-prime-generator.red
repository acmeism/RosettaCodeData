Red [Description: "Prime checker/generator/counter"]

context [
    poke noprime: make bitset! 3 1 true
    top: 2

    noprimes: function [n [integer!] /extern top][
        either top < n [
            n: n + 100
            r: 2
            while [r * r <= n][
                repeat q n / r - 1 [poke noprime q + 1 * r true]
                until [not pick noprime r: r + 1]
            ]
            self/top: n
        ][top]
    ]

    set 'prime? func [
        "Check whether number is prime or return required prime"
        n [integer!]
        /next "Return next closest prime to given number"
        /last "Return last closest prime to given number, or number itself if prime"
        /Nth  "Return Nth prime"
    ][
        noprimes case [
            Nth [to integer! n * 12 ]
            next [n + 100]
            true [n]
        ]
        case [
            next [until [not noprime/(n: n + 1)] n]
            last [while [noprime/:n][n: n - 1] n]
            Nth  [
                cnt: i: 0
                while [cnt < n][
                    until [not noprime/(i: i + 1)]
                    cnt: cnt + 1
                ]
                i
            ]
            true [not noprime/:n]
        ]
    ]

    set 'primes function [
        "Return (number of) primes in given range"
        n [integer!]
        /from     "Start considering primes from `start`"
            start "Default 1"
        /list     "First argument is interpreted as number of primes to list"
        /count    "Count primes from `start`"
    ][
        start: any [start 1]
        either list [
            noprimes start + (n * 12)
        ][
            set [start n] sort reduce [n start]
            noprimes start + n
        ]
        case [
            list [
                start: start - 1
                collect [
                    loop n [
                        until [not noprime/(start: start + 1)]
                        keep start
                    ]
                ]
            ]
            count [
                cnt: 0
                repeat i n - start + 1 [
                    j: i - 1
                    if not noprime/(j + start) [cnt: cnt + 1]
                ]
                cnt
            ]
            true [
                collect [
                    repeat i n - start + 1 [
                        j: i - 1
                        if not noprime/(j: j + start) [keep j]
                    ]
                ]
            ]
        ]
    ]
]
