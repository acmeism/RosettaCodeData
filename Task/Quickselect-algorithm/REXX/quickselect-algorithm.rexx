/*REXX program sorts a list (which may be numbers)  using  quick select.*/
parse arg list;  if list=''  then list=9 8 7 6 5 0 1 2 3 4    /*default?*/
  do #=1  for words(list);   @.#=word(list,#);   end  /*#*/;         #=#-1
                                       /* [↓]  #=number of items in list*/
      do j=1  for #                    /*show  1 ──► #  place and value.*/
      say '         item'  right(j,length(#))",  value: "      qSel(1,#,j)
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────QPART subroutine────────────────────*/
qPart: procedure expose @.; parse arg L 1 ?,R,pivotIndex;pVal=@.pivotIndex
parse  value  @.pivotIndex  @.R  with  @.R  @.pivotIndex  /*swap 2 items*/
          do k=L  to R-1               /*process the left side of list. */
          if @.k>pVal  then iterate    /*when item>pivotValue, skip it. */
          parse value  @.? @.k   with    @.k  @.?         /*swap 2 items*/
          ?=?+1                                           /*next item.  */
          end   /*k*/
parse  value   @.R   @.?     with    @.?   @.R            /*swap 2 items*/
return ?
/*──────────────────────────────────QSEL subroutine─────────────────────*/
qSel: procedure expose @.;    parse arg L,R,z;    if L==R  then return @.L
  do forever                           /*keep looping until all done.   */
  pivotNewIndex=qPart(L, R, (L+R)%2)   /*partition the list into  ≈  ½. */
  pivotDist=pivotNewIndex-L+1
  if pivotDist==z  then return @.pivotNewIndex
                   else if z<pivotDist  then R=pivotNewIndex-1
                                        else do
                                             z=z-pivotDist
                                             L=pivotNewindex+1
                                             end
  end   /*forever*/
