Rebol [
  title: "Rosetta code: Semordnilap"
  file: %Semordnilap.r
  url: https://rosettacode.org/wiki/Semordnilap
  needs: 2.7.0
]

words: read/lines http://wiki.puzzlers.org/pub/wordlists/unixdict.txt
seen: make hash! 200
count: 0

print ["Number of input words: " length? words LF]

foreach word words [
  reversed: reverse copy word
  either find seen reversed [
    count: count + 1
    if count <= 5 [
      print [word "is reversed:" reversed]
    ]
  ][
    append seen word
  ]
]

print [LF "Found total" count "pairs."]
