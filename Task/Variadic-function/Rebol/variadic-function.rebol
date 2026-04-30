REBOL [
	Title: "Variadic Arguments"
]

print-all: func [
    args [block!] {the arguments to print}
] [
    foreach arg args [print arg]
]

print-all [rebol works this way]
