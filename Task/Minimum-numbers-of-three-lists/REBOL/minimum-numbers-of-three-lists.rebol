Rebol [
    title: "Rosetta code: Minimum numbers of three lists"
    file:  %Minimum_numbers_of_three_lists.r3
    url:   https://rosettacode.org/wiki/Minimum_numbers_of_three_lists
]

numbers1: [ 5 45 23 21 67]
numbers2: [43 22 78 46 38]
numbers3: [ 9 98 12 98 53]

probe collect [
    repeat i length? numbers1 [
        keep min min numbers1/:i numbers2/:i numbers3/:i
    ]
]
