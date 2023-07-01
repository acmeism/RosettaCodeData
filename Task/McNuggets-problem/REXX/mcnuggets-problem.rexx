/*REXX pgm solves the  McNuggets problem:  the largest McNugget number for given meals. */
parse arg y                                      /*obtain optional arguments from the CL*/
if y='' | y=","  then y= 6 9 20                  /*Not specified?  Then use the defaults*/
say 'The number of McNuggets in the serving sizes of: '    space(y)
$=
#= 0                                             /*the Y list must be in ascending order*/
z=.
       do j=1  for words(y);      _= word(y, j)  /*examine  Y  list for dups, neg, zeros*/
       if _==1               then signal done    /*Value ≡ 1?  Then all values possible.*/
       if _<1                then iterate        /*ignore zero and negative # of nuggets*/
       if wordpos(_, $)\==0  then iterate        /*search for duplicate values.         */
            do k=1  for #                        /*   "    "  multiple     "            */
            if _//word($,k)==0  then iterate j   /*a multiple of a previous value, skip.*/
            end   /*k*/
       $= $ _;      #= # + 1;     $.#= _         /*add─►list; bump counter; assign value*/
       end        /*j*/
if #<2                     then signal done      /*not possible, go and tell bad news.  */
_= gcd($)        if _\==1  then signal done      /* "     "       "  "   "    "    "    */
if #==2   then z= $.1 * $.2  -  $.1  -  $.2      /*special case, construct the result.  */
if z\==.  then signal done
h= 0                                             /*construct a theoretical high limit H.*/
       do j=2  for #-1;  _= j-1;       _= $._;       h= max(h, _ * $.j  -  _  -  $.j)
       end   /*j*/
@.=0
       do j=1  for #;    _= $.j                  /*populate the  Jth + Kth   summand.   */
         do a=_  by _  to h;           @.a= 1    /*populate every multiple as possible. */
         end   /*s*/

         do k=1  for h;  if \@.k  then iterate
         s= k + _;       @.s= 1                  /*add two #s;   mark as being possible.*/
         end   /*k*/
       end     /*j*/

       do z=h  by -1  for h  until \@.z          /*find largest integer not summed.     */
       end     /*z*/
say
done:  if z==.  then say 'The largest McNuggets number not possible.'
                else say 'The largest McNuggets number is: '          z
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gcd: procedure; $=;    do j=1  for arg();  $=$ arg(j);  end;  $= space($)
     parse var $ x $;     x= abs(x);
       do  while $\=='';  parse var $ y $;  y= abs(y);  if y==0  then iterate
         do  until y==0;  parse value  x//y  y   with   y  x;  end
       end;              return x
