/*REXX program finds and displays the   home prime   of a range of positive integers.   */
numeric digits 20                                /*ensure handling of larger integers.  */
parse arg  LO HI .                               /*obtain optional arguments from the CL*/
if LO=='' | LO=="," then LO=  2                  /*Not specified?  Then use the default.*/
if HI=='' | HI=="," then HI= 20                  /* "     "         "   "   "     "     */
@hpc= 'home prime chain for '                    /*a literal used in two SAY statements.*/
                                 w= length(HI)   /*HI width, used for output alignment. */
       do j=max(2, LO)  to HI                    /*find home primes for an integer range*/
       pf= factr(j);             f= words(pf)    /*get prime factors; number of factors.*/
       if f==1  then do;  say @hpc j": "  j  ' is prime.';  iterate;  end   /*J is prime*/
       xxx.1= j                                  /*save  J  in the first array element. */
                do n=2  until #==1               /*keep processing until we find a prime*/
                xxx.n= space(pf, 0)              /*obtain factors of a concatenated p.f.*/
                pf= factr(xxx.n);   #= words(pf) /*assign factors to PF;  # of factors. */
                end   /*n*/
       ee= n                                     /*save  EE  as the final (last) prime. */
       n= n - 1;   z= n                          /*adjust N (for DO loop); assign N to Z*/
       $=                                        /*nullify the string of   home primes. */
                do m=1  for n                    /*build a list  ($)  of     "     "    */
                $= $  'HP'xxx.m"("z') ─► '       /*concatenate to string of  "     "    */
                z= z - 1                         /*decrease the index counter by unity. */
                end   /*m*/                      /* [↑]  the index counter is decreasing*/

       say @hpc right(j, w)":"   $   xxx.ee  ' is prime.'  /*show string of home primes.*/
       end   /*n*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
factr: procedure;  parse arg x 1 d,$             /*set X, D  to argument 1;  $  to null.*/
       if x==1  then return ''                   /*handle the special case of   X = 1.  */
         do  while x//2==0; $= $ 2; x= x% 2; end /*append all the  2  factors of new  X.*/
         do  while x//3==0; $= $ 3; x= x% 3; end /*   "    "   "   3     "     "  "   " */
         do  while x//5==0; $= $ 5; x= x% 5; end /*   "    "   "   5     "     "  "   " */
         do  while x//7==0; $= $ 7; x= x% 7; end /*   "    "   "   7     "     "  "   " */
       q= 1;                              r= 0   /*R:  will be iSqrt(x).             ___*/
         do  while q<=x; q=q*4; end              /*these two lines compute integer  √ X */
         do  while q>1;  q=q%4; _= d-r-q; r= r%2; if _>=0  then do; d= _; r= r+q; end; end

         do k=11  by 6  to r                     /*insure that  J  isn't divisible by 3.*/
         parse var k  ''  -1  _                  /*obtain the last decimal digit of  K. */
         if _\==5  then  do  while x//k==0;  $=$ k;  x=x%k;  end    /*maybe reduce by K.*/
         if _ ==3  then iterate                  /*Is next  Y  is divisible by 5?  Skip.*/
         y= k+2;         do  while x//y==0;  $=$ y;  x=x%y;  end    /*maybe reduce by Y.*/
         end   /*k*/
                                                 /* [↓]  The $ list has a leading blank.*/
       if x==1  then return $                    /*Is residual=unity? Then don't append.*/
                     return $ x                  /*return   $   with appended residual. */
