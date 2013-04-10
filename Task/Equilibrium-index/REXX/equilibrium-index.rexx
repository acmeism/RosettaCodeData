/*REXX program finds the equalibrium index  for an numeric array (list).*/
parse arg x                            /*get the array's numbers.       */
say '         array list: ' x          /*echo the array list to screen. */
say                                    /* ... and a blank line.         */
k=0                                    /*needed for array list counter. */
         do j=0                        /*start J at 1 for 1-based arrays*/
         k=k+1                         /*bump counter of array numbers. */
         _=word(x,k)                   /*get the number from the list.  */
         if _=='' then leave           /*if null, then we are done.     */
         A.j=_                         /*define the array element.      */
         end   /*j*/
j=j-1                                  /*fudge DO index for the real cnt*/
ans=equalibriumIndex(0,j)              /*calculate the equalibrium Index*/
@indexes='indices';  if ans==1 then @indexes='index'     /*singular adj.*/
say 'equalibrium'  @indexes": "  ans   /*show equalibrium index/indices.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────EQUALIBRIUMINDEX subroutine─────────*/
equalibriumIndex:  procedure expose A. /*have the array  A.  be exposed.*/
parse arg start,many                   /*start is most likely  0  or 1  */
q=                                     /*equalibrium indexes (so far).  */
               do e=start  to many     /*find various sums  (top/bot).  */
               sumB=0                  /*sum of  bottom part of a list. */
                     do b=start to e-1 /*add the bottom part of a list. */
                     sumB=sumB + A.b   /*add this array element to sumB.*/
                     end   /*b*/
               sumT=0                  /*sum of   top   part of a list. */
                     do t=e+1  to many /*add the  top   part of a list. */
                     sumT=sumT + A.t   /*add this array element to sumT.*/
                     end   /*t*/

               if sumB=sumT then q=q e /*if both sums equal, found one. */
               end            /*e*/
return strip(q)                        /*return the equalibrium list.   */
