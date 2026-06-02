Rebol [
    title: "Rosetta code: Abbreviations, automatic"
    file:  %Abbreviations,_automatic.r3
    url:   https://rosettacode.org/wiki/Abbreviations,_automatic
    needs: 3.0.0
    note:  "Based on Red language solution"
]
data: read/lines %abbrev.txt
foreach line data [                    ;; split data in lines at carriage return & line feed:
    if  empty?  trim line [
        print ""
        continue                       ;; continues at head of loop
    ]
    arr: split line space              ;; now split line in words ; accumulate in array / series
    min: 1                             ;; preset min length
    m: make map! []
    until [                            ;; head is the first position of series
        if head? arr [clear m]         ;; define an empty map (key -value store)
        abbr: copy/part first arr min  ;; copy/part ~  leftstr of first word with length min
        arr: either m/:abbr [          ;; abbreviation already exists ?
        min: min + 1
            head arr                   ;; reset series position to head
        ][                             ;; otherwise ....
            m/:abbr: true              ;; mark abreviation in map as existent
            next arr                   ;; set series position to next word
        ]
        tail? arr                      ;; this is the until condition , end /tail of  series reached ?
    ]
    print [min line]                   ;; print automatically reduces all words in block
]
