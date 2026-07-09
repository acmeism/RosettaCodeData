Rebol [
    title: "Rosetta code: Useless instructions"
    file:  %Useless_instructions.r3
    url:   https://rosettacode.org/wiki/Useless_instructions
]

found?: func [
    "Returns TRUE if value is not NONE."
    value
][
    not none? :value
]

;; found? is redundant in conditions - Rebol treats any non-none/non-false
;; value as truthy, so instead of:
if found? find "abc" "b" [print "Found!"]
;; simply write:
if find "abc" "b" [print "Found!"]
