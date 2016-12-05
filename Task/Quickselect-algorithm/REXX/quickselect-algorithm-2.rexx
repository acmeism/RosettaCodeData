/*REXX program sorts a list (which may be numbers) by using the quick select algorithm. */
parse arg list;  if list=''  then list=9 8 7 6 5 0 1 2 3 4    /*Not given?  Use default.*/
say right('list: ', 22)           list
say
      do #=1  for words(list);  @.#=word(list,#) /*assign all the items ──► @. (array). */
      end   /*#*/                                /* [↑]  #: number of items in the list.*/
#=#-1                                            /*adjust number of items in the list.  */
      do j=1  for #                              /*show  1 ──►  # items place and value.*/
      say right('item', 20)     right(j, length(#))",  value: "      qSel(1, #, j)
      end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
qPart: procedure expose @.;  parse arg L 1 ?,R,X;                xVal=@.X
       call swap X,R                             /*swap the two named items  (X and R). */
                      do k=L  to R-1             /*process the left side of the list.   */
                      if @.k>xVal  then iterate  /*when an item > item #X, then skip it.*/
                      call swap ?,k              /*swap the two named items  (? and K). */
                      ?=?+1                      /*bump the item number (point to next).*/
                      end   /*k*/
       call swap R,?                             /*swap the two named items  (R and ?). */
       return ?                                  /*return the item number to invoker.   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
qSel: procedure expose @.;  parse arg L,R,z;  if L==R  then return @.L  /*only one item?*/
        do forever                               /*keep searching until we're all done. */
        new=qPart(L, R, (L+R)%2)                 /*partition the list into roughly  ½.  */
        $=new-L+1                                /*calculate the pivot distance less L+1*/
        if $==z  then return @.new               /*we're all done with this pivot part. */
                 else if  z<$  then     R=new-1  /*decrease the right half of the array.*/
                               else do; z=z-$    /*decrease the distance.               */
                                        L=new+1  /*increase the  left half of the array.*/
                               end
        end   /*forever*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
swap: parse arg _1,_2;  parse value @._1 @._2  with  @._2 @._1;  return  /*swap 2 items.*/
