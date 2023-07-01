Red ["RPG attributes generator"]

raw-attribute: does [
    sum next sort collect [
        loop 4 [keep random/only 6]
    ]
]

raw-attributes: does [
    collect [
        loop 6 [keep raw-attribute]
    ]
]

valid-attributes?: func [b][
    n: 0
    foreach attr b [
        if attr > 14 [n: n + 1]
    ]
    all [
        n > 1
        greater? sum b 74
    ]
]

attributes: does [
    until [
        valid-attributes? a: raw-attributes
    ]
    a
]

show-attributes: function [a][
    i: 1
    foreach stat-name [
        "Strength"
        "Dexterity"
        "Constitution"
        "Intelligence"
        "Wisdom"
        "Charisma"
    ][
        print [rejoin [stat-name ":"] a/:i]
        i: i + 1
    ]
    print "-----------------"
    print ["Sum:" sum a]
    print [n "attributes > 14"]
]

show-attributes attributes
