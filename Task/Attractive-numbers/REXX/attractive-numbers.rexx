/*REXX program finds and shows lists (or counts) attractive numbers up to a specified N.*/
parse arg N .                                    /*get optional argument from the C.L.  */
if N=='' | N==","  then N= 120                   /*Not specified?  Then use the default.*/
cnt= N<0                                         /*semaphore used to control the output.*/
N= abs(N)                                        /*ensure that  N  is a positive number.*/
call genP 100                                    /*gen 100 primes (high= 541); overkill.*/
sw= linesize()  -  1                             /*SW:    is the usable screen width.   */
if \cnt  then say 'attractive numbers up to and including '      commas(N)        " are:"
#= 0                                             /*number of attractive #'s  (so far).  */
$=                                               /*a list of attractive numbers (so far)*/
    do j=1  for N;   if @.j  then iterate        /*Is it a low prime?  Then skip number.*/
          a= cFact(j)                            /*call cFact to count the factors in J.*/
    if \@.a  then iterate                        /*if # of factors not prime, then skip.*/
    #= # + 1                                     /*bump number of attractive #'s found. */
    if cnt   then iterate                        /*if not displaying numbers, skip list.*/
    cj= commas(j);             _= $ cj           /*append a commatized number to $ list.*/
    if length(_)>sw  then do;  say strip($);  $= cj;  end   /*display a line of numbers.*/
                     else                     $= _          /*append the latest number. */
    end   /*j*/

if $\==''  &  \cnt   then say strip($)           /*display any residual numbers in list.*/
say;     say commas(#)     ' attractive numbers found up to and including '      commas(N)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cFact: procedure;  parse arg z 1 oz;  if z<2  then return z  /*if Z too small, return Z.*/
       #= 0                                      /*#:  is the number of factors (so far)*/
             do  while z//2==0;  #= #+1;  z= z%2;  end  /*maybe add the factor of two.  */
             do  while z//3==0;  #= #+1;  z= z%3;  end  /*  "    "   "     "    " three.*/
             do  while z//5==0;  #= #+1;  z= z%5;  end  /*  "    "   "     "    " five. */
             do  while z//7==0;  #= #+1;  z= z%7;  end  /*  "    "   "     "    " seven.*/
                                                 /* [↑]  reduce  Z  by some low primes. */
          do k=11  by 6  while k<=z              /*insure that  K  isn't divisible by 3.*/
          parse var k  ''  -1  _                 /*obtain the last decimal digit of  K. */
          if _\==5  then do  while z//k==0;  #= #+1;   z= z%k;   end   /*maybe reduce Z.*/
          if _ ==3  then iterate                 /*Next number ÷ by 5?  Skip.   ____    */
          if k*k>oz then leave                   /*are we  greater  than the   √ OZ  ?  */
          y= k + 2                               /*get next divisor,  hopefully a prime.*/
                         do while  z//y==0;  #= #+1;   z= z%y;   end   /*maybe reduce Z.*/
          end   /*k*/
       if z\==1  then return # + 1               /*if residual isn't unity, then add one*/
                      return #                   /*return the number of factors in  OZ. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: procedure expose @.; parse arg n;           @.=0;         @.2= 1;     @.3= 1;   p= 2
        do j=3  by 2  until p==n;   do k=3  by 2  until k*k>j;  if j//k==0  then iterate j
                                    end  /*k*/;             @.j = 1;        p= p + 1
        end   /*j*/;          return             /* [↑]  generate  N  primes.           */
