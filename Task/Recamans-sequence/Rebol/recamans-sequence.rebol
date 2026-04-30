Rebol [
    title: "Rosetta code: Recaman's sequence"
    file:  %Recaman's_sequence.r3
    url:   https://rosettacode.org/wiki/Recaman%27s_sequence
]

recaman-until: function/with [code [block!]][
    r: 0 n: 1
    result: reduce [r] ;; result sequence
    seen:   reduce [r] ;; set of visited values for O(1) duplicate check
    bind code 'n
    until [
        append result r: recaman-succ seen n r
        if new?: not find seen r [ append seen r ]
        ++ n
        do code        ;; evaluate stop condition with current n in scope
    ]
    result
][
    recaman-succ: function [seen [block!] n [integer!] r [integer!]][
        back: r - n
        ;; go back if positive and not already seen, otherwise go forward
        either any [back < 0  find seen back] [r + n] [back]
    ]
]

print "First 15 Recaman numbers:"
print recaman-until [n = 15]
print ""
print "First duplicate Recaman number:"
print last recaman-until [not new?]
