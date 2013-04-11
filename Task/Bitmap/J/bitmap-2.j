   myimg=: makeRGB 5 8               NB. create a bitmap with height 5 and width 8 (black)
   myimg=: 255 makeRGB 5 8           NB. create a white bitmap with height 5 and width 8
   myimg=: 0 255 0 makeRGB 5 8       NB. create a green bitmap with height 5 and width 8
   myimg=: 0 0 255 fillRGB myimg     NB. fill myimg with blue
   colors=: 0 255 {~ #: i.8          NB. black,blue,green,cyan,red,magenta,yellow,white
   myimg=: colors fillRGB myimg      NB. fill myimg with vertical stripes of colors
   2 4 getPixels myimg               NB. get the pixel color from point (2, 4)
255 0 0

   myimg=: (2 4 ; 255 255 255) setPixels myimg   NB. set pixel at point (2, 4) to white
   2 4 getPixels myimg               NB. get the pixel color from point (2, 4)
255 255 255

   }:$ myimg                         NB. get height and width of the image
5 8
