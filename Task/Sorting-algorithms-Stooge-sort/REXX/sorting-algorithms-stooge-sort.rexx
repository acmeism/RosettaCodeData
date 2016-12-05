/*REXX program sorts  an  integer array   @.   [the first element starts at index zero].*/
parse arg N .                                    /*obtain an optional argument from C.L.*/
if N=='' | N==","  then N=19                     /*Not specified?  Then use the default.*/
wV=0                                             /*width of the largest  value,  so far.*/
                do k=0  to N;  @.k=k*2 + k*-1**k /*generate some kinda scattered numbers*/
                if @.k//7==0  then @.k= -100 -k  /*Multiple of 7?  Then make a negative#*/
                wV=max(wV, length(@.k))          /*find maximum width of values, so far.*/
                end   /*k*/                      /* [↑]  //  is REXX division remainder.*/
wN=length(N)                                     /*width of the largest element  number.*/
call show    'before sort'                       /*show the   before   array elements.  */
say copies('▒', wN+wV+ 50)                       /*show a separator line (between shows)*/
call stoogeSort  0, N                            /*invoke the  Stooge Sort.             */
call show    ' after sort'                       /*show the    after   array elements.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: do j=0 to N; say right('element',22) right(j,wN) arg(1)":" right(@.j,wV); end;return
/*──────────────────────────────────────────────────────────────────────────────────────*/
stoogeSort: procedure expose @.;  parse arg i,j                  /*sort from  I ───► J. */
            if @.j<@.i  then parse value @.i @.j  with  @.j @.i  /*swap  @.i  with  @.j */
            if j-i>1    then do;   t=(j-i+1) % 3                 /*%:  integer division.*/
                                   call stoogeSort  i  ,  j-t    /*invoke recursively.  */
                                   call stoogeSort  i+t,  j      /*   "        "        */
                                   call stoogeSort  i  ,  j-t    /*   "        "        */
                             end
            return
