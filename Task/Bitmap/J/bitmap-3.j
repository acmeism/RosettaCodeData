pixellist=: ,"0/~ i. 10  NB. row and column indices for 10 by 10 block of pixels

NB. create 10 by 10 block of magenta pixels in the middle of a 300 by 300 green image
myimg=: ((145 + pixellist) ; 255 0 255) setPixels 0 255 0 makeRGB 300 300

NB. get pixel color for 10x10 block offset from magenta block
subimg=: (140 + pixellist) getPixels myimg
