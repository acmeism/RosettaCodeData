Red ["Sum of cubes"]

sum: 0
repeat i 50 [
    sum: i - 1 ** 3 + sum
    prin pad sum 8
    if i % 10 = 0 [prin newline]
]
