Rebol [
    title: "Rosetta code: Case-sensitivity of identifiers"
    file:  %Case-sensitivity_of_identifiers.r3
    url:   https://rosettacode.org/wiki/Case-sensitivity_of_identifiers
]

dog: "Benjamin" Dog: "Samba" DOG: "Bernie"

print rejoin either/only all [dog = Dog Dog = DOG][
    "There is just one dog named " Dog "."
][  "The three dogs are " dog ", " Dog " and " DOG "."]
