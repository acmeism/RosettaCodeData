Rebol [
    title: "Rosetta code: Find limit of recursion"
    file:  %Find_limit_of_recursion.r3
    url:   https://rosettacode.org/wiki/Find_limit_of_recursion
    note:  "The stack size can be modified at compile time (default is 4MB)."
]

x: 0
recurse: does [++ x recurse]
attempt [recurse]

print ["Recursion limit is:" x]
