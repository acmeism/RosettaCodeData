/*REXX program plots/draws a line using the  Xiaolin Wu  line algorithm.*/
background = 'fa'x                     /*background char: middle-dot.   */
    image. = background                /*fill the array with middle-dots*/
     plotC = '░▒▓█'                    /*chars used for plotting points.*/
       EoE = 1000                      /*EOE = End Of Earth, er... plot.*/
                  do j=-EoE  to +EoE   /*draw grid from lowest──►highest*/
                  image.j.0 = '─'      /*draw the horizontal axis.      */
                  image.0.j = '│'      /*  "   "  verical      "        */
                  end    /*j*/
image.0.0 = '┼'                        /*"draw" the axis origin (char). */
parse arg xi yi xf yf .                /*allow specifying line-end pts. */
if xi=='' | xi==','  then xi =  1      /*if not specified, use default. */
if yi=='' | yi==','  then yi =  2      /* "  "      "       "     "     */
if xf=='' | xf==','  then xf = 11      /* "  "      "       "     "     */
if yf=='' | yf==','  then yf = 12      /* "  "      "       "     "     */
minX=0;    minY=0                      /*used as limits for plotting.   */
maxX=0;    maxY=0                      /*  "   "    "    "      "       */
call line_draw    xi,  yi,  xf,  yf    /*call subroutine and draw line. */
border = 2                             /*allow additional space for plot*/
minX=minX-border*2;  maxX=maxX+border*2
minY=minY-border  ;  maxY=maxY+border
                   do      y=maxY  by -1  to minY;  _=     /*build a row*/
                        do x=minX  to maxX
                        _=_ || image.x.y
                        end  /*x*/
                   say _                                   /*display row*/
                   end       /*y*/
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────────DRAW_LINE subroutine──────────────────*/
line_draw:  procedure expose background image. minX maxX minY maxY plotC
parse arg x1, y1, x2, y2;     switchXY=0;      dx=x2-x1
                                               dy=y2-y1
if abs(dx)<abs(dy) then do
                        parse value  x1 y1  with  y1 x1   /*swap x1 & y1*/
                        parse value  x2 y2  with  y2 x2   /*swap x2 & y2*/
                        parse value  dx dy  with  dy dx   /*swap dx & dy*/
                        end
if x2<x1 then do
              parse value  x1 x2  with  x2 x1             /*swap x1 & x2*/
              parse value  y1 y2  with  y2 y1             /*swap y1 & y2*/
              switchXY=1
              end

gradient = dy/dx
    xend = round(x1)              /*────1st endpoint────────────────────*/
    yend = y1 + gradient * (xend-x1)
  intery = yend + gradient
    xgap = 1 - fpart(x1+.5)
   xpx11 = xend;   ypx11 = floor(yend);       ypx11_=ypx11+1
call plotXY xpx11, ypx11,  brite(1-fpart(yend*xgap)),switchXY
call plotXY xpx11, ypx11_, brite(  fpart(yend*xgap)),switchXY

    xend = round(x2)              /*────2nd endpoint────────────────────*/
    yend = y2 + gradient * (xend-x2)
    xgap = fpart(x2+.5)
   xpx12 = xend;      ypx12 = floor(yend);       ypx12_=ypx12+1
call plotXY xpx12, ypx12,  brite(1-fpart(yend*xgap)), switchXY
call plotXY xpx12, ypx12_, brite(  fpart(yend*xgap)), switchXY

         do x=xpx11+1 to xpx12-1  /*────draw the line───────────────────*/
           !intery  = floor(intery)
           !intery_ = !intery+1
         call plotXY x, !intery,  brite(1-fpart(intery)), switchXY
         call plotXY x, !intery_, brite(  fpart(intery)), switchXY
           intery   = intery + gradient
         end   /*x*/
return
/*────────────────────────────────BRITE subroutine──────────────────────*/
brite:   procedure expose background plotC;         parse arg p
return   substr(background || plotC, 1+round(abs(p)*length(plotC)), 1)
/*────────────────────────────────PLOTXY subroutine─────────────────────*/
plotXY:  procedure expose image. minX maxX minY maxY
parse arg  xx, yy, bc, switchYX;         if switchYX then parse arg yy, xx
image.xx.yy=bc;     minX=min(minX,xx);   maxX=max(maxX,xx)
                    minY=min(minY,yy);   maxY=max(maxY,yy)
return
/*────────────────────────────────FLOOR subroutine──────────────────────*/
floor: procedure; parse arg ?; _=trunc(?);  return _-(?<0)*(?\=_)
/*────────────────────────────────FPART subroutine──────────────────────*/
fpart: procedure; parse arg ?;              return abs(?-trunc(?))
/*────────────────────────────────ROUND subroutine─────────arg2 is place*/
round:            return  format(arg(1), , word(arg(2) 0, 1))
