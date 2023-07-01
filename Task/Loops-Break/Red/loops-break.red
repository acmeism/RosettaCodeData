Red [
    Title: "Loops/Break"
    URL: http://rosettacode.org/wiki/Loops/Break
]

random/seed 2 ; Make repeatable. Delete line for 'true' randomness.

r20: does [(random 20) - 1]

forever [
    prin x: r20
    if 10 = x [break]
    print rejoin [" " r20]
]
print ""
