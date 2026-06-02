Rebol [
    title: "Rosetta code: Strip a set of characters from a string"
    file:  %Strip_a_set_of_characters_from_a_string.r3
    url:   https://rosettacode.org/wiki/Strip_a_set_of_characters_from_a_string
]

strip-chars: func [
    "Removes all occurrences of specified characters from a string."
    str   [any-string!]   "The input string to strip characters from"
    chars [string! char!] "Characters to remove"
][
    trim/with str chars
]
probe strip-chars "She was a soul stripper. She took my heart!" "aei"
