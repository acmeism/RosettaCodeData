Rebol [
    title: "Rosetta code: Append numbers at same position in strings"
    file:  %Append_numbers_at_same_position_in_strings.r3
    url:   https://rosettacode.org/wiki/Append_numbers_at_same_position_in_strings
]

list1: [1 2 3 4 5 6 7 8 9]
list2: [10 11 12 13 14 15 16 17 18]
list3: [19 20 21 22 23 24 25 26 27]

list: array len: length? list1
repeat i len [
    list/:i: to integer! ajoin [list1/:i list2/:i list3/:i]
]
?? list
