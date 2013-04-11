/*REXX program to test  range extraction.                               */
aaa='0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22',
    '23 24 25 27 28 29 30 31 32 33 35 36 37 38 39'
say 'old =' aaa;     say               /*show the old range of numbers. */
new=                                   /*new list  (maybe with ranges). */
w=words(aaa)                           /*number of numbers in the list. */
                  /*Note: index of DO  (J)  gets modified within loop !.*/
  do j=1  to w                         /*step through  num word in list.*/
  _=word(aaa,j)                        /*get the Jth number in the list.*/
  new=new',' _                         /*append  Jth number to new list.*/
  inc=1                                /*start with an increment of one.*/

    do k=j+1  to w                     /*now, search for end of range.  */
    __=word(aaa,k)                     /*get the Kth number in the list.*/
    if __ \== _+inc  then leave        /*this number 1  >  than prev?   */
    inc=inc+1                          /*yes, then increase the range.  */
    g_ = __                            /*placeholder for last good num. */
    end   /*k*/

  k=k-1                                /*fudge the Kth word (subtract 1)*/
  if k  == j    then iterate           /*no range?   Then keep truckin'.*/
  if g_ == _+1  then iterate           /*range of 1? Then keep truckin'.*/
  new=new'-'g_                         /*indicate a range of numbers.   */
  j=k                                  /*Bad practice!! Change DO index.*/
  end   /*j*/

new=substr(new,3)                      /*remove extraneous leading comma*/
new=space(new,0)                       /*remove all spaces (blanks).    */
say 'new =' new                        /*display new list of numbers.   */
                                       /*stick a fork in it, we're done.*/
