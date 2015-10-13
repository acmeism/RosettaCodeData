/*REXX pgm sorts a  list  (which may be numbers) using quick select algorithm.*/
parse arg list;  if list=''  then list=9 8 7 6 5 0 1 2 3 4  /*use the default?*/
      do #=1  for words(list);   @.#=word(list,#)           /*assign item──►@.*/
      end   /*#*/                      /* [↑]  #:  number of items in the list*/
#=#-1                                  /*adjust number of items in the list.  */
      do j=1  for #                    /*show 1 ──► # of items place and value*/
      say right('item',20)     right(j,length(#))",  value: "    qSel(1,#,j)
      end   /*j*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────QPART subroutine──────────────────────────*/
qPart: procedure expose @.;  parse arg L 1 ?,R,X;                   xVal = @.X
call swap X,R                          /*swap the two named items  (X and R). */
             do k=L  to R-1            /*process the left side of the list.   */
             if @.k>xVal  then iterate /*when an item > item #X, then skip it.*/
             call swap ?,k             /*swap the two named items  (? and K). */
             ?=?+1                     /*bump item number we're working with. */
             end   /*k*/
call swap R,?                          /*swap the two named items  (R and ?). */
return ?                                                    /*return item num.*/
/*──────────────────────────────────QSEL subroutine───────────────────────────*/
qSel: procedure expose @.;  parse arg L,R,z;  if L==R  then return @.L  /*one?*/
  do forever                           /*keep searching until we're all done. */
  new=qPart(L, R, (L+R)%2)             /*partition the list into roughly  ½.  */
  dist=new-L+1                         /*calculate the pivot distance less L+1*/
  if dist==z  then return @.new        /*we're all done with this pivot part. */
              else if  z<dist  then      R=new-1      /*decrease right half.  */
                               else do;  z=z-dist     /*decrease the distance.*/
                                         L=new+1      /*increase the left half*/
                                    end
  end   /*forever*/
/*──────────────────────────────────SWAP subroutine───────────────────────────*/
swap: parse arg _1,_2; parse value @._1 @._2 with @._2 @._1; return  /*swap 2.*/
