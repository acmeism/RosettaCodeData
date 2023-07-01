/*REXX program reads a PPM formatted image file,  and creates a gray─scale image of it. */
parse arg iFN oFN                                /*obtain optional argument from the CL.*/
if iFN=='' | iFN==","  then  iFN= 'Lenna50'      /*Not specified?  Then use the default.*/
if oFN=='' | oFN==","  then  oFN= 'greyscale'    /* "      "         "   "   "     "    */
iFID= iFN'.ppm';             oFID= oFN'.ppm'     /*complete the  input and output  FIDs.*/
call charin iFID, 1, 0                           /*set the position of the input file.  */
y=charin(iFID, , copies(9, digits() ) )          /*read the entire input file  ───►  X  */
parse var  y   id  3 c 4 3 width height # pixels /*extract header info from the PPM hdr.*/
      LF= 'a'x                                   /*define a comment separator  (in hdr).*/      /* ◄─── LF delimiters & comments*/
if c==LF  then do;  commentEND=pos(LF, y, 4)     /*point to the last char in the comment*/      /* ◄─── LF delimiters & comments*/
                    parse var  y   =(commentEND)  +1  width  height          #  pixels          /* ◄─── LF delimiters & comments*/
               end                                                                              /* ◄─── LF delimiters & comments*/
                                                 /* [↓]  has an alternative delimiter?  */      /* ◄─── LF delimiters & comments*/
z=pos(LF, height);  if z\==0  then parse var  height height    =(z)   +1     #  pixels          /* ◄─── LF delimiters & comments*/
z=pos(LF, #     );  if z\==0  then parse var  #      #         =(z)   +1        pixels          /* ◄─── LF delimiters & comments*/
chunk=4000                                       /*chunk size to be written at one time.*/
LenPixels= length(pixels)

  do j=0  for 256;  _=d2c(j);   @._=j;   @@.j=_  /*build two tables for fast conversions*/
  end   /*j*/

call charout oFID, ,  1                          /*set the position of the output file. */
call charout oFID, id || width height #' '       /*write the header followed by a blank.*/
!=1
    do until !>=LenPixels;            $=         /*$:      partial output string so far.*/
      do !=!  by 3  for chunk                    /*chunk:  # pixels converted at 1 time.*/
      parse var pixels  =(!)  r +1   g +1   b +1 /*obtain the next  RGB  of a PPM pixel.*/
      if r==''  then leave                       /*has the end─of─string been reached?  */
      _=(.2126*@.r  + .7152*@.g  + .0722*@.b )%1 /*an integer RGB greyscale of a pixel. */
      $=$  ||  @@._  ||  @@._  ||  @@._          /*lump (grey)  R G B  pixels together. */
      end   /*!*/                                /* [↑]  D2C  converts decimal ───► char*/
    call charout oFID, $                         /*write the next bunch of pixels.      */
    end     /*until*/

call charout oFID                                /*close the output file just to be safe*/
say 'File '       oFID       " was created."     /*stick a fork in it,  we're all done. */
