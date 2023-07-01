/*REXX pgm computes and displays a Sierpinski Arrowhead Curve using the characters: \_/ */
parse arg order .                                /*obtain optional argument from the CL.*/
if order=='' | order==","  then order=   5       /*Not specified?  Then use the default.*/
say '  Sierpinski arrowhead curve of order'   order             /*display the   title.  */
say '═════════════════════════════════════════'                 /*   "     "  separator.*/
$= init()                                        /*initialize a bunch of variables.     */
if order//2  then do;  call turn +60;  call curve order, len, -60;  end    /*CURVE odd? */
             else                      call curve order, len, +60          /*CURVE even.*/

       do    row=Ly  to Hy;   a=                 /*show arrowhead graph 1 row at a time.*/
          do col=Lx  to Hx;   a= a || @.col.row  /*build a row of   "   " col  " "   "  */
          end   /*col*/;  say strip(a, 'T')      /*show  "  "   "   "     row  " "   "  */
       end      /*row*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
init:  @.=" "; #=0; len=512; x=len; y=x;Hx=x;Hy=y;Lx=x;Ly=y; return '@. # Hx Hy Lx Ly x y'
turn:  parse arg angle; #= (#+angle)//360;  if #<0  then #= #+360;  return  /*normalize.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
curve: procedure expose ($);  parse arg order,len,angle  /*$:  list of exposed variables*/
       if order==0  then call draw len                   /*Is ORDER zero?  Then draw it.*/
                    else do;  call curve order-1, len/2, -angle;      call turn angle
                              call curve order-1, len/2, +angle;      call turn angle
                              call curve order-1, len/2, -angle
                         end
       return                                    /*The  CURVE  function is recursive.   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
draw:  select                                    /*draw part of the curve using a char. */
           when #==  0  then do;    @.x.y= '_';      x= x + 1;                        end
           when #== 60  then do;    @.x.y= '/';      x= x + 1;        y= y - 1;       end
           when #==120  then do;    x= x - 1;        @.x.y= '\';      y= y - 1;       end
           when #==180  then do;    x= x - 1;        @.x.y= '_';                      end
           when #==240  then do;    x= x - 1;        y= y + 1;        @.x.y= '/';     end
           when #==300  then do;    y= y + 1;        @.x.y= '\';      x= x + 1;       end
           end   /*select*/                      /*curve character is based on direction*/
       Lx= min(Lx,x);  Hx= max(Hx,x);  Ly= min(Ly,y);  Hy= max(Hy,y)  /*min&max  of  x,y*/
       return                                    /*#:  heading in degrees of the curve. */
