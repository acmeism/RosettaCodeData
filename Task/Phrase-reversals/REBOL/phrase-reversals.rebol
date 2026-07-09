Rebol [
    title: "Rosetta code: Phrase reversals"
    file:  %Phrase_reversals.r3
    url:   https://rosettacode.org/wiki/Phrase_reversals
]

print phrase: "rosetta code phrase reversal"
print reverse copy phrase
print collect [
    foreach word split phrase space [keep reverse word]
]
print reverse split phrase space
