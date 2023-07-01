/*REXX program sorts a list (4 groups) of integers using the  bead sort algorithm. */
/* original source by Gerard Schildberger                                          */
/* 20230605 Walter Pachl reformatted and refurbished                               */
                                 /* define  two dozen  grasshopper  numbers.       */
                                 /* source ??                                      */
gHopper=1 4 10 12 22 26 30 46 54 62 66 78 94 110 126 134 138 158 162 186 190 222 254,
        270
                                 /* these are also called hexagonal pyramidal #s.  */
                                 /* see https://oeis.org/A002412                   */
greenGrocer=0 4 16 40 80 140 224 336 480 660 880 1144 1456 1820 2240 2720 3264 3876,
        4560
                                 /* define twenty-three Bernoulli numerator numbers*/
                                 /* source ?? quotes needed because of negative #s.*/
bernN='1 -1 1 0 -1 0 1 0 -1 0 5 0 -691 0 7 0 -3617 0 43867 0 -174611 0'
                                 /* also called the Reduced Totient function,      */
                                 /* and is also called Carmichael lambda,          */
                                 /* or the LAMBDA function                         */
                          /* see https://en.wikipedia.org/wiki/Carmichael_function */
psi=1 1 2 2 4 2 6 2 6 4 10 2 12 6 4 4 16 6 18 4 6 10 22 2 20 12 18 6 28 4 30 8 10 16
list=gHopper greenGrocer bernN psi           /*combine the four lists into one list.*/
Call show 'before sort',list                 /*display the  list  before sorting.   */
Say copies('¦', 75)                          /*show long separator line before sort.*/
Call show ' after sort',beadSort(list)       /*display the  list  after sorting.    */
Exit                                         /*stick a fork in it, we're all done.  */
/*----------------------------------------------------------------------------------*/
beadSort: Procedure
  Parse Arg list 1 low . 1 high .            /* List to be sorted and first value   */
  occurences.=0                              /* count stem occurences               */
  Do Until list==''                          /* loop through the list               */
    Parse Var list bead list                 /* take an element                     */
    bead= bead / 1                           /* normalize the value                 */
    occurences.bead=occurences.bead + 1      /* bump occurences                     */
    low= min(low, bead)                      /* track lowest                        */
    high=max(high,bead)                      /* and highest number                  */
    End
  sorted=''                                  /* now, collect the beads              */
  Do v=low To high
    If occurences.v>0 Then
      sorted=sorted copies(v' ', occurences.v)
    End
  Return sorted
/*----------------------------------------------------------------------------------*/
show:
  Parse Arg txt,slist
  n=words(slist)
  w=length(n)
  Do k=1 For n
    Say right('element',30) right(k,w) txt':' right(word(slist,k),9)
    End
  Return
