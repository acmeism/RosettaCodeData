Red []
#include %environment/console/CLI/input.red
random/seed now
print "I have thought of a number between 1 and 10. Try to guess it."
number: random 10
while [(to integer! input) <> number][
    print "Your guess was wrong. Try again."
]
print "Well guessed!"
