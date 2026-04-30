Red [ "Word frequency - hinjolicious" ]

word-freq: function [file n][
  word-chars: charset "abcdefghijklmnopqrstuvwxyz"
  words: parse lowercase read file [collect [any [keep [some word-chars] | skip]]]
  freq: make map! []
  foreach w words [freq/:w: either none? freq/:w [1][freq/:w + 1]]
  sorted: sort/reverse collect [foreach [w c] freq [keep/only reduce [c w]]]
]

sorted: word-freq %135-0.txt 10

print "Top 10 word frequency:"
repeat i 10 [w: sorted/:i print [pad w/2 10 w/1]]
