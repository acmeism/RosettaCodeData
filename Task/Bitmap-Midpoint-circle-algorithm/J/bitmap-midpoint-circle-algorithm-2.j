myimg=: 0 255 0 makeRGB 25 25                              NB. 25 by 25 green image
myimg=: (12 12 12 ; 255 0 0) drawCircles myimg              NB. draw red circle with radius 12
viewRGB ((12 12 9 ,: 12 12 6) ; 0 0 255) drawCircles myimg  NB. draw two more concentric circles
