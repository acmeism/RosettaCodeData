Rebol [
    title: "Rosetta code: Random numbers"
    file:  %Random_numbers.r3
    url:   https://rosettacode.org/wiki/Random_numbers
]

box-muller: func [
    {Returns normally distributed random value with given mean and standard deviation}
    mean [number!]
    std  [number!]
][
    mean + (std * (sqrt -2.0 * log-e random 1.0) * cos (2.0 * pi * random 1.0))
]

values: make vector! [float32! 1000]
repeat i 1000 [
    values/:i: box-muller 1.0 0.5
]

print as-yellow "First 5 values:"
print copy/part values 5
print ""
print as-yellow "Statistics:"
print query values object!
