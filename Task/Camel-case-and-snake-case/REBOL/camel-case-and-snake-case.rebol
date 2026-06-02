Rebol [
    title: "Rosetta code: Camel case and snake case"
    file:  %Camel_case_and_snake_case.r3
    url:   https://rosettacode.org/wiki/Camel_case_and_snake_case
]

cammel-case-split: function/with [
    "Split a camelCase string into a block of words"
    input [string!]
][
    parse/case input [
        collect any [
            [
                ahead upper s: skip [to upper | to end] e:
                | end reject
                | s: [to upper | to end] e:
            ] keep ( copy/part s e )
        ]
    ]
][  upper: charset [#"A" - #"Z"] ]

to-snake-case: function[
    "Convert a string to snake_case"
    input [string!]
][
    out: lowercase ajoin/with cammel-case-split input #"_"
    div: charset " -_"
    parse trim/head/tail out [any [to div change some div #"_"]]
    out
]

to-camel-case: function[
    "Convert a string to camelCase"
    input [string!]
][
    out: copy ""
    foreach p split input charset " _-" [
        append out uppercase/part p 1
    ]
    lowercase/part out 1
    out
]

tests: [
    "snakeCase"
    "snake_case"
    "variable_10_case"
    "variable10Case"
    "ɛrgo rE tHis"
    "hurry-up-joe!"
    "c://my-docs/happy_Flag-Day/12.doc"
    "  spaces  "
]

print "                             === To snake_case ==="
foreach test tests [
    printf [-35 " --> " ][mold test mold to-snake-case test]
]
print ""
print "                             === To camelCase ==="
foreach test tests [
    printf [-35 " --> " ][mold test mold to-camel-case test]
]
