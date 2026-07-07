Rebol [
    title: "Rosetta code: Partial function application"
    file:  %Partial_function_application.r3
    url:   https://rosettacode.org/wiki/Partial_function_application
]

;; Create a function fs( f, s ) that takes a function, f( n ), of one value and a sequence of values s.
fs: func [
    {Apply f to each element of s, returning a new sequence.}
    f [function!] s [block!]
][  map-each v s [f v] ]

;; Create function f1 that takes a value and returns it multiplied by 2.
f1: func [{Return n multiplied by 2.} n] [n * 2]
;; Create function f2 that takes a value and returns it squared.
f2: func [{Return n squared.}         n] [n * n]

;; 1st partial version
partial-v1: func [
    {Return a closure with f bound into fs.}
    f [function!]
][
    closure/with [s] [fs :_f s] [_f: :f]  ;; captures f via closure context
]

;; 2nd partial version
partial-v2: func [
    {Return a func with f composed into body.}
    f [function!]
][
    func [s] compose [fs quote (:f) s]    ;; bakes f literally into body
]

fsf1: partial-v1 :f1 ;; Partially apply f1 to fs to form function fsf1( s )
fsf2: partial-v2 :f2 ;; Partially apply f2 to fs to form function fsf2( s )

;; Test fsf1 and fsf2 by evaluating them
foreach test [
    [fsf1 [0 1 2 3]]
    [fsf1 [2 4 6 8]]
    [fsf2 [0 1 2 3]]
    [fsf2 [2 4 6 8]]
][
    print [mold/only test "==" as-green mold try test]
]
