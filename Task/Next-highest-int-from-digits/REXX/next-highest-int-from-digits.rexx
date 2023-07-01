/*REXX program finds the  next highest positive integer  from a list of decimal digits. */
parse arg n                                      /*obtain optional arguments from the CL*/
if n='' | n=","  then n= 0 9 12 21 12453 738440 45072010 95322020    /*use the defaults?*/
w= length( commas( word(n, words(n) ) ) )        /*maximum width number  (with commas). */

     do j=1  for words(n);        y= word(n, j)  /*process each of the supplied numbers.*/
     masky= mask(y)                              /*build a digit mask for a supplied int*/
     lim= copies(9, length(y) )                  /*construct a  LIMIT  for the DO loop. */

          do #=y+1  to lim  until mask(#)==masky /*search for a number that might work. */
          if verify(y, #) \== 0  then iterate    /*does # have all the necessary digits?*/
          end   /*#*/

     if #>lim  then #= 0                         /*if # > lim,  then there is no valid #*/
     say 'for ' right(commas(y),w) " ─── the next highest integer is: " right(commas(#),w)
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do ?=length(_)-3  to 1  by -3;  _= insert(',', _, ?); end;  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
mask: parse arg z, $;   @.= 0                    /* [↓]  build an  unsorted digit mask. */
                          do k=1  for length(z);    parse var z _ +1 z;     @._= @._ + 1
                          end   /*k*/
        do m=0  for 10;         if @.m==0  then iterate;            $= $ || copies(m, @.m)
        end   /*m*/;      return $               /* [↑]  build  a    sorted  digit mask.*/
