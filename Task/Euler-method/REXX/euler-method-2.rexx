/*REXX pgm solves example of Newton's cooling law via Euler's method (diff. step sizes).*/
e=2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138
numeric digits length(e)   -  length(.)          /*use the number of decimal digits in E*/
parse arg Ti Tr cc tt ss                         /*obtain optional arguments from the CL*/
if Ti='' | Ti=","  then Ti= 100                  /*given?  Default:  initial temp in ºC.*/
if Tr='' | Tr=","  then Tr=  20                  /*  "         "       room    "   "  " */
if cc='' | cc=","  then cc=   0.07               /*  "         "     cooling constant.  */
if tt='' | tt=","  then tt= 100                  /*  "         "    total time seconds. */
if ss='' | ss=","  then ss=   2  5  10           /*  "         "      the step sizes.   */
@= '═'                                           /*the character used in title separator*/
     do sSize=1  for words(ss);    say;    say;    say center('time in'     , 11)
     say center('seconds' , 11, @)                     center('Euler method', 16, @) ,
         center('analytic', 18, @)                     center('difference'  , 14, @)
     $=Ti;                  inc= word(ss, sSize) /*the 1st value;  obtain the increment.*/
          do t=0  to Ti  by inc                  /*step through calculations by the inc.*/
          a= format(Tr + (Ti-Tr)/exp(cc*t),6,10) /*calculate the analytic (exact) value.*/
          say center(t,11)  format($,6,3)  'ºC '  a  "ºC"  format(abs(a-$)/a*100,6,2)  '%'
          $= $   +   inc * cc * (Tr-$)           /*calc. next value via Euler's method. */
          end   /*t*/
     end        /*sSize*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
exp: procedure expose e; arg x; ix= x%1; if abs(x-ix)>.5  then ix=ix+sign(x); x= x-ix; z=1
     _=1;  w=1;    do j=1;  _= _*x/j;    z= (z+_)/1;      if z==w  then leave;         w=z
                   end  /*j*/;           if z\==0  then z= e**ix * z;             return z
