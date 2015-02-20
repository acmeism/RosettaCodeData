REBOL []

print "NUMBER REVERSAL GAME"

tries: 0
goal: [1 2 3 4 5 6 7 8 9]
random/seed now

until [
    jumble: random goal
    jumble != goal ; repeat in the unlikely case that jumble isn't jumbled
]

while [jumble != goal] [
    prin jumble
    prin " How many to flip? "
    flip-index: to-integer input ; no validation!
    reverse/part jumble flip-index
    tries: tries + 1
]

print rejoin ["You took " tries " attempts."]
