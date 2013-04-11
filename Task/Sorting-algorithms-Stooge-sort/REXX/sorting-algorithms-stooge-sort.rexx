/*REXX program to sort an integer array   L   [elements start at zero]. */
highItem=19                            /*define  0 ──► 19  elements.    */
widthH=length(highItem)                /*width of biggest element number*/
widthL=0                               /*width of largest element value.*/

    do k=0  to highItem                /*populate the array with stuff. */
    L.k=2*k + (k * -1**k)              /*kinda generate randomish nums. */
    if L.k==0  then L.k=-100-k         /*if zero, make a negative number*/
    widthL=max(widthL,length(L.k))     /*compute maximum width so far.  */
    end   /*k*/

call showL 'before sort'               /*show the before array elements.*/
call stoogeSort 0,highItem             /*invoke the Stooge Sort.        */
call showL ' after sort'               /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOWL subroutine────────────────────*/
showL: sepLength=22+widthH+widthL      /*compute separator width.       */
say copies('-',sepLength)              /*show the 1st separator line.   */

               do j=0  to highItem
               say 'element' right(j,widthH) arg(1)":" right(L.j,widthL)
               end    /*j*/

say copies('=', sepLength)             /*show the 2nd separator line.   */
return
/*──────────────────────────────────STOOGESORT subroutine───────────────*/
stoogeSort: procedure expose L.;  parse arg i,j     /*sort from I ──> J.*/
if L.j<L.i then parse value L.i L.j  with  L.j L.i  /*swap  L.i with L.j*/
if j-i>1  then do
               t=(j-i+1) % 3           /* %  is REXX integer division.  */
               call stoogesort i  , j-t
               call stoogesort i+t, j
               call stoogesort i  , j-t
               end
return
