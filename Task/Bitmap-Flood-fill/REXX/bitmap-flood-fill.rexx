/*REXX program  demonstrates a  method  to  perform a  flood fill  of an area.          */
black= '000000000000000000000000'b               /*define the black color  (using bits).*/
red  = '000000000000000011111111'b               /*   "    "   red    "       "     "   */
green= '000000001111111100000000'b               /*   "    "  green   "       "     "   */
white= '111111111111111111111111'b               /*   "    "  white   "       "     "   */
                                                 /*image is defined to the test image.  */
hx=125;  hy=125                                  /*define limits  (x,Y)  for the image. */
area=white;     call fill 125,  25, red          /*fill the white area in red.          */
area=black;     call fill 125, 125, green        /*fill the center orb in green.        */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fill: procedure expose image. hx hy area;  parse arg x,y,fill_color   /*obtain the args.*/
      if x<1 | x>hx | y<1 | y>hy   then return   /*X or Y  are outside of the image area*/
      pixel=@(x, y)                              /*obtain the color of the  X,Y  pixel. */
      if pixel\==area  then return               /*the pixel has already been filled    */
                                                 /*with the  fill_color,  or we are not */
                                                 /*within the area to be filled.        */
      image.x.y=fill_color                       /*color desired area with fill_color.  */
      pixel=@(x  , y-1);    if pixel==area  then call fill x  , y-1, fill_color  /*north*/
      pixel=@(x-1, y  );    if pixel==area  then call fill x-1, y  , fill_color  /*west */
      pixel=@(x+1, y  );    if pixel==area  then call fill x+1, y  , fill_color  /*east */
      pixel=@(x  , y+1);    if pixel==area  then call fill x  , y+1, fill_color  /*south*/
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
@:    parse arg $x,$y;      return image.$x.$y   /*return with color of the  X,Y  pixel.*/
