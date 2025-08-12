Rebol [
  title: "Rosetta code: Semordnilap"
  file: %Semordnilap.r3
  url: https://rosettacode.org/wiki/Semordnilap
  needs: 3.14.0
]

words: read/lines http://wiki.puzzlers.org/pub/wordlists/unixdict.txt
seen: make map! 200
count: 0

print ["Number of input words: " length? words LF]

foreach word words [
  reversed: reverse copy word
  either find seen reversed [
    if ++ count <= 5 [
      print [word "is reversed:" reversed]
    ]
  ][
    put seen word reversed
  ]
]

print [LF "Found total" count "pairs."]
