Rebol [
    title: "Rosetta code: Short-circuit evaluation"
    file:  %Short-circuit_evaluation.r3
    url:   https://rosettacode.org/wiki/Short-circuit_evaluation
]

a: func [v][ print ["called function A with:" v] v]
b: func [v][ print ["called function B with:" v] v]

print as-yellow "Using AND/OR:"
print as-gray   "AND/OR always evaluate both arguments — no short-circuit"
print ""
foreach i [#(true) #(false)] [
    foreach j [#(true) #(false)] [
        print [tab "The result of A(i) AND B(j) is:" (a i) and (b j)]
    ]
]
print ""
foreach i [#(true) #(false)] [
    foreach j [#(true) #(false)] [
        print [tab "The result of A(i) OR B(j) is:" (a i) or (b j)]
    ]
]

print-hline/width 50
print as-yellow "Using ALL/ANY:"
print as-gray   "ALL/ANY evaluate left to right and stop as soon as the result is determined:"
print as-gray   "ALL stops on first false, ANY stops on first true — so B may not be called"
print ""
foreach i [#(true) #(false)] [
    foreach j [#(true) #(false)] [
        print [tab "The result of ALL [A(i) B(j)] is:" all [(a i) (b j)]]
    ]
]
print ""
foreach i [#(true) #(false)] [
    foreach j [#(true) #(false)] [
        print [tab "The result of ANY [A(i) B(j)] is:" any [(a i) (b j)]]
    ]
]
