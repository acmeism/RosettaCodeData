Rebol [
    title: "Rosetta code: Longest string challenge"
    file:  %Longest_string_challenge.r3
    url:   https://rosettacode.org/wiki/Longest_string_challenge
    note:  {
        Original list of restrictions:
        * No comparison operators may be used.
        * No arithmetic operations, such as addition and subtraction, may be used.
        * The only datatypes you may use are integer and string.
          In particular, you may not use lists.
        * Do not re-read the input file. Avoid using files as a replacement for
          lists (this restriction became apparent in the discussion).
    }
]

longer?: func [
    "True if s1 is longer than s2 (character walk, no length?)"
    s1 [string!] s2 [string!]
][
    forever [
        case [
            all [tail? s1 not tail? s2] [return false] ;; s1 exhausted first
            tail? s2                    [return true ] ;; s2 exhausted first
        ]
        ;; advance both pointers
        s1: next s1
        s2: next s2
    ]
    false
]

longest-strings: function [
    "Return a block of the longest string(s) from a block of strings."
    strings [block!]
][
    output:  copy ""                       ;; intentionally not using block!
    longest: strings/1
    foreach str next strings [
        is-longer: longer? str longest
        case [
            all [is-longer longer? longest str] [ ;; equal length -> collect
                append append output lf str
            ]
            is-longer [                           ;; new longest -> replace
                append append clear output lf longest: str
            ]
        ]
    ]
]

data: ["a" "bb" "ccc" "ddd" "ee" "f" "ggg"]
;; Using block of strings, but it could be resolved like:
;; data: read/lines %task-data.txt

print ["Longest strings:" as-green longest-strings :data]
