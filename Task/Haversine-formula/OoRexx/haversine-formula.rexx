/*REXX pgm calculates distance between Nashville & Los Angles airports. */
say " Nashville:  north 36º  7.2', west  86º 40.2'   =   36.12º,  -86.67º"
say "Los Angles:  north 33º 56.4', west 118º 24.0'   =   33.94º, -118.40º"
say
dist=surfaceDistance(36.12,  -86.67,  33.94,  -118.4)
kdist=format(dist/1       ,,2)         /*show 2 digs past decimal point.*/
mdist=format(dist/1.609344,,2)         /*  "  "   "    "     "      "   */
ndist=format(mdist*5280/6076.1,,2)     /*  "  "   "    "     "      "   */
say ' distance between=  '  kdist  " kilometers,"
say '               or   '  mdist  " statute miles,"
say '               or   '  ndist  " nautical or air miles."
exit                                   /*stick a fork in it, we're done.*/
/*----------------------------------SURFACEDISTANCE subroutine----------*/
surfaceDistance: arg th1,ph1,th2,ph2   /*use haversine formula for dist.*/
  radius = 6372.8                      /*earth's mean radius in km      */
  ph1 = ph1-ph2
  x = cos(ph1) * cos(th1) - cos(th2)
  y = sin(ph1) * cos(th1)
  z = sin(th1) - sin(th2)
  return radius * 2 * aSin(sqrt(x**2+y**2+z**2)/2 )

cos: Return RxCalcCos(arg(1))
sin: Return RxCalcSin(arg(1))
asin: Return RxCalcArcSin(arg(1),,'R')
sqrt: Return RxCalcSqrt(arg(1))
::requires rxMath library
