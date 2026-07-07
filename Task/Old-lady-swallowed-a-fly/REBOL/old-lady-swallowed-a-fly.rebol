Rebol [
    title: "Rosetta code: Old lady swallowed a fly"
    file:  %Old_lady_swallowed_a_fly.r3
    url:   https://rosettacode.org/wiki/Old_lady_swallowed_a_fly
]

animals: [
    fly spider bird cat dog goat cow horse
]
verses: [
    "I don't know why she swallowed that fly.^/Perhaps she'll die"
    "That wiggled and jiggled and tickled inside her"
    "How absurd, to swallow a bird"
    "Imagine that. She swallowed a cat"
    "What a hog to swallow a dog"
    "She just opened her throat and swallowed that goat"
    "I don't know how she swallowed that cow"
    "She's dead of course"
]

repeat i length? animals [
    print ["There was an old lady who swallowed a" animals/:i]
    print verses/:i
    if i < length? animals [
        for j i 2 -1 [
            print ["She swallowed the" animals/:j "to catch the" animals/(j - 1)]
            if j = 2 [print verses/1]
        ]
    ]
    print ""
]
