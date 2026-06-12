/*REXX program performs nimber arithmetic  (addition and multiplication); shows a table.*/
numeric digits 40;         d= digits() % 8       /*use a big enough number of decimals. */
parse arg sz aa bb .                             /*obtain optional argument from the CL.*/
if sz=='' | sz==","  then sz=    15              /*Not specified?  Then use the default.*/
if aa=='' | aa==","  then aa= 21508              /* "      "         "   "   "     "    */
if bb=='' | bb==","  then bb= 42689              /* "      "         "   "   "     "    */
w= max(4,length(sz)); @.= '+';  @.1= "*"; _= '═' /*calculate the width of the table cols*/
            != '║';     sz1= sz + 1;     w1= w-1 /*define the "dash" character for table*/
   do am=0  for 2                                /*perform sums, then perform multiplies*/
   call top ! || center("("@.am')', w1)          /*show title of table.  */
           do j=0  for sz1; $= !||center(j, w1)! /*calculate & format a row of the table*/
                     do k=0  for sz1                            /*build a row of table. */
                     if am  then $= $ || right( nprod(j, k), w) /*append to a table row.*/
                            else $= $ || right(  nsum(j, k), w) /*   "    " "   "    "  */
                     end   /*k*/
           say $ !                                              /*show a row of a table.*/
           end             /*j*/
   call bot
   end                     /*am*/

say 'nimber   sum   of '   comma(aa)   " and "   comma(bb)  ' ───► '  comma( nsum(aa, bb))
say 'nimber product of '   comma(aa)   " and "   comma(bb)  ' ───► '  comma(nprod(aa, bb))
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hdr:   $= ? || !; do i=0  to sz; $=$ || right(i,w); end; say $ !;         call sep; return
top:   $= '╔'copies(_, w1)"╦"copies(copies(_, w), sz1)_; say $'╗'; arg ?; call hdr; return
sep:   $= '╠'copies(_, w1)"╬"copies(copies(_, w), sz1)_; say $'╣';                  return
bot:   $= '╚'copies(_, w1)"╩"copies(copies(_, w), sz1)_; say $'╝'; say;   say;      return
comma: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?= insert(',', ?, jc); end;  return ?
d2b:   procedure; parse arg z;    return right( x2b( d2x(z) ), digits(), 0)
hpo2:  procedure; parse arg z;    return 2 ** (length( d2b(z) + 0)   -   1)
lhpo2: procedure; arg z; m=hpo2(z); q=0;  do while m//2==0; m= m%2; q= q+1; end;  return q
nsum:  procedure expose d; parse arg x,y;     return c2d( bitxor( d2c(x,d),  d2c(y,d) ) )
shl:   procedure; parse arg z,h;              return z * (2**h)
shr:   procedure; parse arg z,h;              return z % (2**h)
/*──────────────────────────────────────────────────────────────────────────────────────*/
nprod: procedure expose d; parse arg x,y;  if x<2 | y<2  then return x * y;     h= hpo2(x)
       if x>h        then return nsum( nprod(h, y),   nprod( nsum(x, h), y)  )
       if hpo2(y)<y  then return nprod(y, x)
       ands= c2d(bitand(d2c(lhpo2(x), d), d2c(lhpo2(y), d)));  if ands==0  then return x*y
       h= hpo2(ands);     return nprod( nprod( shr(x,h), shr(y,h) ),  shl(3, h-1)  )
