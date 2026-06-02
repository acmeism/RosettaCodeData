Rebol [
    title: "Rosetta code: Sudan function"
    file:  %Sudan_function.r3
    url:   https://rosettacode.org/wiki/Sudan_function
]

sudan: function [
    "Compute the Sudan function, a non-primitive recursive function"
    n [integer!] "Recursion depth"
    x [integer!]
    y [integer!]
][
    if n = 0 [return x + y]                             ;; base: addition
    if y = 0 [return x]                                 ;; base: identity
    sudan n - 1 (sudan n x y - 1) y + (sudan n x y - 1) ;; double recursion
]

print ["sudan 0 0 0 ==" sudan 0 0 0]
print ["sudan 1 1 1 ==" sudan 1 1 1]
print ["sudan 2 1 1 ==" sudan 2 1 1]
print ["sudan 3 1 1 ==" sudan 3 1 1]
print ["sudan 2 2 1 ==" sudan 2 2 1]
