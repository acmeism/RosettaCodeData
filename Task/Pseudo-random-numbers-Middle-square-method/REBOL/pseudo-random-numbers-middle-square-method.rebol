Rebol [
    title: "Rosetta code: Pseudo-random numbers/Middle-square method"
    file:  %Pseudo-random_numbers-Middle-square_method.r3
    url:   https://rosettacode.org/wiki/Pseudo-random_numbers/Middle-square_method
]

rand: function/with [
    "Generate a pseudo-random integer between 0 and 999999."
    /seed "Initialize the random seed"
     num [number!]
][
    if seed [s: num exit]
    s: to integer! (s * s / 1000) % 1000000
][  s: 675248 ]

loop 5 [print rand]
print "^/restart"
rand/seed 675248
loop 5 [print rand]
