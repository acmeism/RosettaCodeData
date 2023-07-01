:-  %say
|=  [* * [bottles=_99 ~]]
:-  %noun
^-  wall
=/  output  `(list tape)`~
|-
?:  =(1 bottles)
  %-  flop
  :-  "1 bottle of beer on the wall"
  :-  "Take one down, pass it around"
  :-  "1 bottle of beer"
  :-  "1 bottle of beer on the wall"
      output
%=  $
  bottles  (dec bottles)
  output
  :-  "{<bottles>} bottles of beer on the wall"
  :-  "Take one down, pass it around"
  :-  "{<bottles>} bottles of beer"
  :-  "{<bottles>} bottles of beer on the wall"
      output
==
