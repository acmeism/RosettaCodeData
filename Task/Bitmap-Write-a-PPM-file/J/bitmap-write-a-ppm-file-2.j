   NB. create 10 by 10 block of magenta pixels in top right quadrant of a 300 wide by 600 high green image
   pixellist=: >,{;~i.10
   myimg=: ((150 + pixellist) ; 255 0 255) setPixels 0 255 0 makeRGB 600 300
   myimg writeppm jpath '~temp/myimg.ppm'
540015
