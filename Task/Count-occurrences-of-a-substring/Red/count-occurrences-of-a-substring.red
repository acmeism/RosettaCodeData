Red []

count-occurrences: function [string substring] [
    length? parse string [collect [some [keep substring to substring]]]
]

test-case-1: "the three truths"
test-case-2: "ababababab"

print [test-case-1 "-" count-occurrences test-case-1 "th"]
print [test-case-2 "-" count-occurrences test-case-2 "abab"]
