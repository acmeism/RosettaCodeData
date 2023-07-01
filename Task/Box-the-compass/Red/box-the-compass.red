Red []

d:  charset [#"N"  #"E" #"S" #"W"]                                                ;; main directions
hm: #()                                                                           ;; hm = hashmap - key= heading, value = [box , compass point]

compass-points: [N NbE NNE NEbN NE NEbE ENE EbN E EbS ESE SEbE SE SEbS SSE
 SbE S SbW SSW SWbS SW SWbW WSW WbS W WbN WNW NWbW NW NWbN NNW NbW N ]

expand: func [cp repl][                                                         ;; expand compass point to words
  parse cp [ copy a thru d ahead 2 d insert "-" ]                               ;; insert "-" after first direction, if followed by 2 more
  foreach [src dst ] repl  [ replace/all cp to-string src to-string dst ]       ;; N -> north ...
  uppercase/part cp 1                                                           ;; convert first letter to uppercase
]

print-line: does [ print [pad/left hm/:heading/1 3   pad  hm/:heading/2 20  heading ] ]

forall compass-points [
 i: (index? compass-points) - 1                                                       ;; so i = 0..33
 heading: i * 11.25 + either 1 = rem: i % 3  [ 5.62]                                  ;; rem = remainder
                                             [ either  rem = 2 [-5.62] [0.0] ]
  hm/:heading:  reduce [ (i % 32 + 1 ) expand to-string compass-points/1 [N north b " by " S south E east W west] ]
  print-line heading
]
