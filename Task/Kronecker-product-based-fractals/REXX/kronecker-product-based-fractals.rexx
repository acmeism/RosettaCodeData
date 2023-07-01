/*REXX program calculates the   Kronecker product   of   two arbitrary size   matrices. */
parse arg pGlyph .                               /*obtain optional argument from the CL.*/
if pGlyph=='' | pGlyph==","  then pGlyph= '█'    /*Not specified?  Then use the default.*/
if length(pGlyph)==2  then pGlyph= x2c(pGlyph)   /*Plot glyph is 2 chars?   Hexadecimal.*/
if length(pGlyph)==3  then pGlyph= d2c(pGlyph)   /*  "    "    " 3   "      Decimal.    */
       aMat= 3x3  0 1 0 1 1 1 0 1 0              /*define  A  matrix size  and elements.*/
       bMat= 3x3  1 1 1 1 0 1 1 1 1              /*   "    B     "     "    "     "     */
call makeMat 'A', aMat                           /*construct   A   matrix from elements.*/
call makeMat 'B', bMat                           /*    "       B      "     "     "     */
call KronMat 'Kronecker product'                 /*calculate the  Kronecker  product.   */
call showMat 'Kronecker product', result         /*display   the  Kronecker  product.   */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
KronMat: parse arg what;              #= 0;           parse var  @.a.shape  aRows  aCols
                                                      parse var  @.b.shape  bRows  bCols
           do       rA=1  for aRows
             do     rB=1  for bRows;  #= # + 1;       ##= 0;         _=
               do   cA=1  for aCols;  x= @.a.rA.cA
                 do cB=1  for bCols;  y= @.b.rB.cB;   ##= ## + 1;   xy= x * y;     _= _ xy
                 @.what.#.##= xy
                 end   /*cB*/
               end     /*cA*/
             end       /*rB*/
           end         /*rA*/;        return aRows * aRows   ||   'X'   ||   bRows * bRows
/*──────────────────────────────────────────────────────────────────────────────────────*/
makeMat: parse arg what, size elements;   arg , row 'X' col .;      @.what.shape= row  col
         #=0;    do   r=1  for row               /* [↓]  bump item#; get item; max width*/
                   do c=1  for col;   #= # + 1;        @.what.r.c= word(elements, #)
                   end   /*c*/                   /* [↑] define an element of WHAT matrix*/
                 end     /*r*/;           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat: parse arg what, size .;   parse var size  row  'X'  col   /*obtain mat name, sz*/
                     do    r=1  for row;    $=                     /*build row by row.  */
                        do c=1  for col;    $= $ || @.what.r.c     /*  "   col  " col.  */
                        end   /*c*/
                     $= translate($, pGlyph, 10)                   /*change──►plot glyph*/
                     say strip($, 'T')                             /*display line──►term*/
                     end     /*r*/;       return
