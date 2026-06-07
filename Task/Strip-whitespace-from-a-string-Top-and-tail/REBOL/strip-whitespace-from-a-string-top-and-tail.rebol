Rebol [
    title: "Rosetta code: Strip whitespace from a string/Top and tail"
    file:  %Strip_whitespace_from_a_string-Top_and_tail.r3
    url:   https://rosettacode.org/wiki/Strip_whitespace_from_a_string/Top_and_tail
]

str: "     Hello World     "

print [pad "strip leading:"  15 mold trim/head      copy str]
print [pad "strip trailing:" 15 mold trim/tail      copy str]
print [pad "strip all:"      15 mold trim/head/tail copy str]
