   ^.%:_2                                 NB. ln ∘ sqrt; gives complex numbers for inputs < 0
0.346574j1.5708
   sqrt=. %: fail ([: +./ <&0)            NB. return Nothing where result would've been complex
   ln  =. ^. fail ([: +./ <:&0)           NB. same
   show ln bind sqrt bind unit 2 3 4
`Just 0.346574 0.549306 0.693147
   show ln bind sqrt bind unit 2 _3 4     NB. short-circuits on input < 0
`Nothing
   show@(ln bind)@(sqrt bind)@unit&> 2 _3 4
`Just 0.346574
`Nothing
`Just 0.693147
   show unit@:*:`ln`sqrt comp 2 3 4
`Just 0.120113 0.301737 0.480453
