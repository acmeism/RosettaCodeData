Red ["Sleeping Beauty problem"]

experiments: 1'000'000
heads: awakenings: 0
loop experiments [
    awakenings: awakenings + 1
    either 1 = random 2 [heads: heads + 1] [awakenings: awakenings + 1]
]
print ["Awakenings over" experiments "experiments:" awakenings]
print ["Probability of heads on waking:" heads / awakenings]
