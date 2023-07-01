/*REXX program sorts a list (which may be numbers)  by using the quick select algorithm.*/
parse arg list;  if list=''  then list= 9 8 7 6 5 0 1 2 3 4   /*Not given?  Use default.*/
say right('list: ', 22)           list
#= words(list)
              do i=1  for #;  @.i= word(list, i) /*assign all the items ──► @. (array). */
              end   /*i*/                        /* [↑]  #: number of items in the list.*/
say
      do j=1  for #                              /*show  1 ──►  # items place and value.*/
      say right('item', 20)     right(j, length(#))",  value:  "      qSel(1, #, j)
      end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
qPart: procedure expose @.;  parse arg L 1 ?,R,X;               xVal= @.X
       parse value  @.X @.R   with   @.R @.X     /*swap the two names items  (X and R). */
             do k=L  to R-1                      /*process the left side of the list.   */
             if @.k>xVal  then iterate           /*when an item > item #X, then skip it.*/
             parse value @.? @.k  with  @.k @.?  /*swap the two named items  (? and K). */
             ?= ? + 1                            /*bump the item number (point to next).*/
             end   /*k*/
       parse       value @.R @.?  with  @.? @.R  /*swap the two named items  (R and ?). */
       return ?                                  /*return the item number to invoker.   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
qSel: procedure expose @.;  parse arg L,R,z;  if L==R  then return @.L  /*only one item?*/
        do forever                               /*keep searching until we're all done. */
        new= qPart(L, R, (L+R) % 2)              /*partition the list into roughly  ½.  */
        $= new - L + 1                           /*calculate pivot distance less  L+1.  */
        if $==z  then return @.new               /*we're all done with this pivot part. */
                 else if  z<$  then     R= new-1 /*decrease the right half of the array.*/
                               else do; z= z-$   /*decrease the distance.               */
                                        L= new+1 /*increase the  left half *f the array.*/
                                    end
        end   /*forever*/
