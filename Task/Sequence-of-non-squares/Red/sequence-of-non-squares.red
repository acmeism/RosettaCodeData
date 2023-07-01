Red ["Sequence of non-squares"]

repeat i 999'999 [
    n: i + round/floor 0.5 + sqrt i
    if i < 23 [prin [to-integer n ""]]
    if equal? round/floor n sqrt n [
        print "Square found!"
        break
    ]
]
