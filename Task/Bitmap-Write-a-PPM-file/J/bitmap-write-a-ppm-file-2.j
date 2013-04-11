   NB. create 10 by 10 block of magenta pixels in top right quadrant of a 300 wide by 600 high green image
   myimg=: ((145 + pixellist) ; 255 0 255) setPixels 0 255 0 makeRGB 600 200
   myimg writeppm jpath '~temp/myimg.ppm'
360015
