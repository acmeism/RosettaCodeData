Rebol [
    title: "Rosetta code: Look-and-say sequence"
    file:  %Look-and-say_sequence.r3
    url:   https://rosettacode.org/wiki/Look-and-say_sequence
]

look-and-say: function [
    "Recursive function that generates the nth term of the Look-and-Say sequence"
    n [integer!]
][
    if n = 0 [return "1"]                          ;; base case: 0th term is "1"
    previous: look-and-say n - 1                   ;; recursively get the previous term
    result: clear ""                               ;; start with an empty result string
    counter: 0                                     ;; tracks the length of the current run
    char: previous/1                               ;; start comparison from the first character
    foreach ch previous [
        either char <> ch [                        ;; character changed — end of a run
            if counter > 0 [
                append result ajoin [counter char] ;; append "count + digit" to result
            ]
            counter: 1                             ;; reset counter for the new character
            char: ch                               ;; track the new character
        ][
            ++ counter                             ;; same character, extend the current run
        ]
    ]
    ajoin [result counter char]                    ;; append the final run and return
]

for x 0 10 1 [ print [pad x -2 "->" look-and-say x] ]
