Red[]

lower: 1
upper: 100
print ["Please think of a number between" lower "and" upper]

forever [
    guess: to-integer upper + lower / 2
    print ["My guess is" guess]
    until [
        input: ask "Is your number (l)ower, (e)qual to, or (h)igher than my guess? "
        find ["l" "e" "h"] input
    ]
    if "e" = input [break]
    either "l" = input [upper: guess] [lower: guess]
]

print ["I did it! Your number was" guess]
