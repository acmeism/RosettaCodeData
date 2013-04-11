'white blue yellow black orange red'=: 255 255 255,0 0 255,255 255 0,0 0 0,255 165 0,:255 0 0
myimg=: white makeRGB 50 70
lines=: (_2]\^:2) 0 0 25 0 , 25 0 25 35 , 25 35 0 35 , 0 35 0 0
myimg=: (lines;blue) drawLines myimg
myimg=: (3 3; yellow) floodFill myimg
myimg=: ((35 25 24 ,: 35 25 10);black) drawCircles myimg
myimg=: (5 34;orange) floodFill myimg
myimg=: (5 36;red) floodFill myimg
viewRGB myimg
