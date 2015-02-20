/*REXX pgm runs FRACTRAN for a given set of fractions and from a given N*/
numeric digits 999                     /*be able to handle larger nums. */
parse arg N terms fracs                /*get optional arguments from CL.*/
if N==''    |    N==',' then N=2       /*N specified?   No, use default.*/
if terms==''|terms==',' then terms=100 /*TERMS specified?   Use default.*/
if fracs=''             then fracs= ,  /*any fractions specified?  No···*/
'17/91, 78/85, 19/51, 23/38, 29/33, 77/29, 95/23, 77/19, 1/17, 11/13, 13/11, 15/14, 15/2, 55/1'
f=space(fracs,0)                       /* [↑] use default for fractions.*/
                 do i=1  while f\=='';    parse var f n.i '/' d.i ',' f
                 end   /*i*/           /* [↑]   parse all the fractions.*/
#=i-1                                  /*the number of fractions found. */
say # 'fractions:'  fracs              /*display # and actual fractions.*/
say 'N  is starting at '  N            /*display the starting number  N.*/
say terms  ' terms are being shown:'   /*display a kind of header/title.*/

    do j=1  for  terms                 /*perform loop once for each term*/
       do k=1  for  #;  if N//d.k\==0  then iterate    /*not an integer?*/
       say right('term' j,35) '──► ' N /*display the Nth term  with  N. */
       N = N   %  d.k  *  n.k          /*calculate the next term (use %)*/
       leave                           /*go start calculating next term.*/
       end   /*k*/                     /* [↑]  if integer, found a new N*/
    end      /*j*/
                                       /*stick a fork in it, we're done.*/
