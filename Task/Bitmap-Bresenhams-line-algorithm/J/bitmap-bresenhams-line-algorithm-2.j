   myimg=: 0 255 0 makeRGB 20 32                       NB. 32 by 20 green image
   myimg=: ((1 1 ,: 5 11) ; 255 0 0 ) drawLines myimg  NB. draw red line from xy point 1 1 to 11 5

NB. Works for lists of 2 by 2 arrays each defining a line's start and end point.
   Diamond=: _2]\ _2]\ 9 5 5 15 , 5 15 9 25 , 9 25 13 15 , 13 15 9 5
   Square =: _2]\ _2]\ 5 5 5 25 , 5 25 13 25 , 13 25 13 5 , 13 5 5 5
   viewRGB myimg=: (Diamond;255 0 0) drawLines myimg   NB. draw 4 red lines to form a diamond
   viewRGB myimg=: (Square;0 0 255) drawLines myimg    NB. draw 4 blue lines to form a square
   viewRGB (Diamond;255 0 0) drawLines (Square;0 0 255) drawLines myimg
