myimg=: 0 0 255 makeRGB 300 300
]randomctrlpts=: ,3 2 ?@$ }:$ myimg                               NB. 3 control points - quadratic
]randomctrlpts=: ,4 2 ?@$ }:$ myimg                               NB. 4 control points - cubic
myimg=: ((2 ,.~ _2]\randomctrlpts);255 0 255) drawCircles myimg   NB. draw control points
viewRGB (randomctrlpts; 255 255 0) drawBezier myimg               NB. display image with bezier line
