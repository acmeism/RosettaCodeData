Red [
  Title: "99 Bottles of Beer"
  Original-Author: oofoe
]

; The 'bottles' function maintains correct grammar.

bottles: function [n] [
  b: either 1 = n ["bottle"]["bottles"]
  if 0 = n [n: "no"]
  form reduce [n b]
]

repeat x 99 [
  n: 100 - x
  print [
    bottles n "of beer on the wall"     crlf
    bottles n "of beer"                 crlf
    "Take one down, pass it around"     crlf
    bottles n - 1 "of beer on the wall" crlf
  ]]
