Rebol [
    title: "Rosetta code: Sleeping Beauty problem"
    file:  %Sleeping_Beauty_problem.r3
    url:   https://rosettacode.org/wiki/Sleeping_Beauty_problem
]

experiments: 1'000'000          ;; total runs
heads: awakenings: 0            ;; counters

loop experiments [
    ++ awakenings               ;; always wake Monday
    either 1 = random 2 [
        ++ heads                ;; heads -> record & sleep
    ][  ++ awakenings ]         ;; tails -> wake again Tuesday
]

print ["Awakenings over" experiments "experiments:" awakenings]
print ["Probability of heads on waking:" heads / awakenings]
