Rebol [
    title: "Rosetta code: Bioinformatics/Sequence mutation"
    file:  %Bioinformatics-Sequence_mutation.r3
    url:   https://rosettacode.org/wiki/Bioinformatics-Sequence_mutation
]

bases: "ATGC"

pretty-print: function [dna][
    count: #[] foreach base bases [count/:base: 0]
    i: 1
    forskip dna 50 [
        line: copy/part dna 50
        prin format [-4 ":"][i * 50 - 50 + min 50 length? dna]
        forskip line 10 [
            prin ["" copy/part line 10]
        ]
        print ""
        foreach key line [
            count/:key: 1 + count/:key
        ]
        i: i + 1
    ]
    print ["Total count:" mold count]
]

perform-random-modifications: function [dna times] [
    result: copy dna
    loop times [
        index: random length? result
        switch random 3 [
            1 [
                prev: result/:index
                until [prev != base: random/only bases]
                result/:index: base
                print [" changing base" prev "at position" pad index 3 "to" base]
            ]
            2 [
                insert at result index base: random/only bases
                print ["inserting base" base "at position" index]
            ]
            3 [
                base: take at result index
                print [" deleting base" base "at position" index]
            ]
        ]
    ]
    result
]

dna: "" loop 200 [append dna random/only bases]
print "------------------------------"
print " Initial sequence"
print "------------------------------"
pretty-print dna
print ""

print "------------------------------"
print " Modifying sequence"
print "------------------------------"
dna: perform-random-modifications dna 10
print ""

print "------------------------------"
print " Final sequence"
print "------------------------------"
pretty-print dna
print ""
