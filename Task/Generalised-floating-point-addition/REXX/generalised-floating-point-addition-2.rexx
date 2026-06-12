/*REXX program performs  generalized floating point addition  using  BCD  numbers.      */
parse arg base .                                 /*obtain optional argument from the CL.*/
if base=='' | base==","  then base= 10           /*Not specified?  Then use the default.*/
maxW= linesize() - 1                             /*maximum width allowed for displays.  */
                                                 /*Not all REXXes have the LINESIZE BIF.*/
_123= 012345679;   reps= 0;   mult= 63           /*vars used to construct test cases.   */
say ' # addend               uncompressed (zoned) BCD number'       /*display the header*/
say left('── ────── ─', maxW, '─')                                  /*   "    header sep*/

   do j=-7  to 21                                /*traipse through the test cases.      */
   reps= reps + 1                                /*increase number of repetitions.      */
   BCD.j= strip(copies(_123, reps)'^'mult,'L',0) /*construct a zoned BCD.               */
   if j//3==0  then BCD.J= '+'BCD.j              /*add a leading plus sign every 3rd #. */
   parse var BCD.j '^' pow                       /*get the exponent part of the number. */
   addend.j= '1e'pow                             /*build exponent addend the hard way.  */
   _= right(j, 2)  right(addend.j, 6)            /*construct the prefix for a line.     */
   aLine= _  BCD.j                               /*construct a line for the output.     */
   if length(aLine)<maxW  then say aLine         /*Does it fit on a line?  Display it.  */
                          else say _ ' ['length(BCD.j)  "digits]"         /*otherwise...*/
   mult= mult - 9                                /*decrease the multiplier's exponent.  */
   maxDigs= length(BCD.j) + abs(pow) + 5         /*compute the maximum precision needed.*/
   if maxDigs>digits()  then numeric digits maxDigs         /*increase digits if needed.*/
   end    /*j*/

say copies('═', maxW)                            /*display a fence for separation.      */
times= 81                                        /*the number of times to   add   it.   */

   do k=-7  to 21                                /*traipse through the test cases.      */
   parse var BCD.k   mantissa  '^'  exponent     /*decompose the zoned  BCD  number.    */
   x= mantissa'e'exponent                        /*reconstitute the original number.    */
   sum= 0                                        /*prepare for the 81 additions.        */
               do times
               sum= sum + x                      /*multiplying the hard way, yuppers!   */
               end

   sum= (sum + addend.k) / 1                     /*one method to elide trailing zeroes. */
   _= format(sum, , , , 0)                       /*force sum ──► exponential format.    */
   _bX= base(_ / 1,  base)                       /*this expresses    _   in base  BASE. */
   say right(k,3) 'sum=' translate(_bX, "e", 'E')  /*use a lowercase "E" for exponents. */
   end   /*k*/                                   /*output is in base   BASEX.           */

exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
base: procedure;  parse arg x 1 s 2 1 ox,tt,ii,left_,right_;   f= 'BASE'
      @#= 0123456789;  @abc='abcdefghijklmnopqrstuvwxyz';      @abcu= @abc;   upper @abcu
      $= $basex()                                /*character string of maximum base.    */
      m= length($) - 1                           /*M:  the maximum base that can be used*/
      c= left_\=='' | right_\==''
      if tt==''  then tt= 10                     /*assume base  ten  if omitted.        */
      if ii==''  then ii= 10                     /*assume base  ten  if omitted.        */
      i= abs(ii)
      t= abs(tt)
      if t==999 | t=="*"  then t= m
      if t>m & \c  then call er81 t,2 m f'-to'
      if i>m       then call er81 i,2 m f'-from'

      if \c  then do                             /*build character string for base ?    */
                  != substr($, 1 + 10*(tt<0), t) /*the character string for base  T.    */
                  if tt<0  then != 0  ||  !      /*prefix a zero  if  negative base.    */
                  end

      if x==''  then if c  then return left_ || t || right_
                           else return left(!, t)

      @= substr($, 1 + 10*(ii<0), i)              /*@:  legal characters for base  X.   */
      oS=                                         /*the original sign placeholder.      */
      if s='-' | s="+"  then do                   /*process the sign (if any).          */
                             x= substr(x,2)       /*strip the sign character.           */
                             oS= s                /*save the original sign glyph.       */
                             end

      if (ii>10 & ii<37) | (ii<0 & ii>-27)  then upper x     /*should we uppercase it ? */

                                                  /*Base 10?   Then it must be a number.*/

      if pos('-', x)\==0 |,                       /*too many minus signs ?              */
         pos('+', x)\==0 |,                       /*too many  plus signs ?              */
         x==.            |,                       /*is it a single decimal point ?      */
         x==''               then call er53 ox    /* ...  or a single  +  or  -  sign ? */

      parse var x   w  '.'  g                     /*sep whole number from the fraction. */
      if pos(., g)\==0  then call er53 ox         /*too many decimals points?           */
      items.1= 0                                  /*number of whole part "digits".      */
      items.2= 0                                  /*number of fractional "digitsd".     */

      if c  then do                               /*any "digit" specifiers ?            */
                     do while w\==''              /*process the  "whole"  part.         */
                     parse var w    w.1  (left_)  w.2  (right_)  w
                       do j=1  for 2;  if w.j\==''  then call putit w.j,1
                       end   /*j*/
                     end     /*while*/

                     do while g\==''              /*process the fractional part.        */
                     parse var g g.1 (left_) g.2 (right_) g
                       do j=1  for 2;        if g.j\==''  then call putit g.j,2
                       end   /*j*/
                     end     /*while*/

                 _= 0;       p= 0                 /*convert the whole number part.      */

                   do j=items.1 to 1 by -1;  _= _ + item.1.j * (i**p)
                   p= p + 1                          /*increase the power of the base.  */
                   end   /*j*/

                 w=_;        p= 0;      _= 0      /*convert the fractional part.        */

                   do j=1 to items.2;        _=_+item.2.j/i**p
                   p= p + 1                       /*increase power of the base.         */
                   end   /*j*/

                 g= strip( strip(_, 'L', 0), , .) /*strip leading decimal point.        */
                 if g=0  then g=                  /*no signifcant fract. part.*/
                 end

      __= w || g                                  /*verify re-composed number.*/
      _= verify(__,@'.')                          /*# have any unusual digits?*/
      if _\==0  then call er48,ox,substr(__, _, 1)    '[for'    f    i"]"    /*oops─say.*/

      if i\==10  then do                           /*convert number base I ──► base 10. */
                                                   /*...  but only if not base 10.      */
                      _= 0;  p= 0                  /*convert the whole number part.     */

                                       do j=length(w)  to 1  by -1   while w\==''
                                       _= _ + ((pos( substr(w, j, 1),  @) - 1)  * i **p)
                                       p= p + 1    /*increase the power of the base.    */
                                       end   /*j*/
                      w= _;  _= 0;   p= 1          /*convert the fractional part.       */

                         do j=1  for length(g)
                         _= _ d + ( (pos( substr(g, j, 1), @) - 1)   /  i**p)
                         p= p + 1                  /*increase the power of the base.    */
                         end   /*j*/
                      g= _
                      end
                 else if g\=='' then g="."g        /*reinsert the period if needed.     */

      if t\==10  then do                           /*convert base10 number to base  T.  */
                      if w\=='' then do            /*convert the whole number part.     */
                                           do j=1;   _= t**j;      if _>w  then leave
                                           end   /*J*/
                                     n=
                                         do k=j-1  to 1  by -1;    _= t**k;      d= w % _
                                         if c  then n= n      left_ || d || right_
                                               else n= n  ||  substr(!,  1 + d,  1)
                                         w= w // _
                                         end   /*k*/
                                     if c  then w= n      left_  ||  w  ||  right_
                                           else w= n  ||  substr(!, 1 + w,  1)
                                     end

                      if g\=='' then do;  n=       /*convert the fractional part.       */
                                              do digits()+1;   if g==0 then leave
                                              p= g * t;        g = p // 1;   d= trunc(p)
                                               if c  then n= n      left_ || d || right_
                                                     else n= n  ||  substr(!,  d + 1,  1)
                                              end   /*digits···*/
                                      if n==0    then n=
                                      if n\==''  then n= '.'n   /*is it only a fraction?*/
                                      g= n
                                    end
                      end

      return oS || p( strip( space(w), 'L', 0)strip( strip(g, , 0),  "T",.)   0)
/*──────────────────────────────────────────────────────────────────────────────────────*/
$basex: return @# || @abcu || @abc || space( translate(,
        xrange('1'x, "fe"x), , @#'.+-'@abc || @abcu"0708090a0b0c0d"x),  0)
/*──────────────────────────────────────────────────────────────────────────────────────*/
num:    procedure;   parse arg x .,f,q;  if x=='' then return x
        if isnum(x)  then return x/1;    x= space( translate(x, , ','), 0)
        if isnum(x)  then return x/1;    return numnot()
/*──────────────────────────────────────────────────────────────────────────────────────*/
putit:  parse arg px,which;  if \isint(px)  then px= numx(px)
        items.which= items.which + 1;       _= items.which;    item.which._= px;    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
er:     say '***error!***'; say; say arg(1); say; exit 13
er48:   call er arg(1) 'contains invalid characters:'  arg(2)
er53:   call er arg(1) 'not numeric'
er81:   call er arg(1) 'must be in the range:'         arg(2)
isint:  return datatype( arg(1), 'W')
isnum:  return datatype( arg(1), 'N')
numnot: if q==1  then return x;                        call er53 x
numx:   return num( arg(1), arg(2), 1)
p:      return subword( arg(1), 1, max(1, words( arg(1) ) - 1) )
