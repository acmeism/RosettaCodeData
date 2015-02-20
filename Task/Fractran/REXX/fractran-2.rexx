/*REXX pgm runs FRACTRAN for a given set of fractions and from a given N*/
numeric digits 999; w=length(digits()) /*be able to handle larger nums. */
parse arg N terms fracs                /*get optional arguments from CL.*/
if N==''    |    N==',' then N=2       /*N specified?   No, use default.*/
if terms==''|terms==',' then terms=100 /*TERMS specified?   Use default.*/
if fracs=''             then fracs= ,  /*any fractions specified?  No···*/
'17/91, 78/85, 19/51, 23/38, 29/33, 77/29, 95/23, 77/19, 1/17, 11/13, 13/11, 15/14, 15/2, 55/1'
f=space(fracs,0)                       /* [↑] use default for fractions.*/
L=length(N)                            /*length in decimal digits of  N.*/
tell= terms>0                          /*flag:  show #  or a power of 2.*/
                 do i=1  while f\=='';    parse var f n.i '/' d.i ',' f
                 end   /*i*/           /* [↑]   parse all the fractions.*/
!.=0                                   /*default value  for powers of 2.*/
if \tell  then do p=0  until length(_)>digits();     _=2**p;       !._=1
               if p<2  then @._=left('',w+9)          '2**'left(p,w)   " "
                       else @._='(prime' right(p,w)")  2**"left(p,w)   ' '
               end   /*p*/             /* [↑]  build powers of 2 tables.*/
#=i-1                                  /*the number of fractions found. */
say # 'fractions:'  fracs              /*display # and actual fractions.*/
say 'N  is starting at '  N            /*display the starting number  N.*/
if tell  then say terms  ' terms are being shown:'        /*display hdr.*/
         else say 'only powers of two are being shown:'   /*   "     "  */
q='(max digits used: '                 /*a literal used in the SAY below*/

  do j=1  for  abs(terms)              /*perform loop once for each term*/
     do k=1  for  #;  if N//d.k\==0  then iterate      /*not an integer?*/
     if tell then say right('term' j,35) '──► ' N   /*display Nth term&N*/
             else if !.N  then say right('term' j,15) '──►' @.N q,
                                   right(L,w)")  "       N         /*2ⁿ.*/
     N = N   %  d.k  *  n.k            /*calculate the next term (use %)*/
     L=max(L, length(N))               /*maximum number of decimal digs.*/
     leave                             /*go start calculating next term.*/
     end   /*k*/                       /* [↑]  if integer, found a new N*/
  end      /*j*/
                                       /*stick a fork in it, we're done.*/
