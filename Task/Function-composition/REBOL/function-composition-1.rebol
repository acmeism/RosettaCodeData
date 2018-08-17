REBOL [
	Title: "Functional Composition"
	URL: http://rosettacode.org/wiki/Functional_Composition
]

; "compose" means something else in REBOL, therefore I use a 'compose-functions name.

compose-functions: func [
    {compose the given functions F and G}
    f [any-function!]
    g [any-function!]
] [
    func [x] compose [(:f) (:g) x]
]
