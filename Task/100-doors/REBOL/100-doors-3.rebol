;; Loop variable i from 1 to 10 (since 10^2 = 100, covers doors 1 to 100)
repeat i 10 [
    ;; Print that door number (i squared) is open
    ;; These are exactly the doors with perfect square numbers: 1, 4, 9, ..., 100
    print ["door" (i * i) "is open"]
]
