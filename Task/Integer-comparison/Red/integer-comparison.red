Red [
    Title: "Comparing Two Integers"
    URL: http://rosettacode.org/wiki/Comparing_two_integers
    Date: 2021-10-25
]

a: to-integer ask "First integer? " b: to-integer ask "Second integer? "

relation: [
    a < b "less than"
    a = b "equal to"
    a > b "greater than"
]
print [a "is" case relation b]
