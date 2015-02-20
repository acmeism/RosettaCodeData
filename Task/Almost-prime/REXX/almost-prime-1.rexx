/*REXX program displays the  N  numbers of the first  K  k-almost primes*/
parse arg N K .                        /*get the arguments from the C.L.*/
if N==''  then N=10                    /*No  N?    Then use the default.*/
if K==''  then K=5                     /* "  K?      "   "   "     "    */
                                       /* [↓]   display one line per  K.*/
     do m=1  for  K;    $=2**m;  fir=$ /*generate the 1st k_almost prime*/
     #=1;      if #==N  then leave     /*# k-almost primes; 'nuff found?*/
     sec=3*(2**(m-1));  $=$ sec;  #=2  /*generate the 2nd k-almost prime*/
         do j=fir+fir+1  until #==N    /*process an almost-prime N times*/
         if #factr(j)\==m then iterate /*not the correct k-almost prime?*/
         #=#+1                         /*bump the k-almost prime counter*/
         $=$ j                         /*append k-almost prime to list. */
         end   /*j*/                   /* [↑]   gen  N  k-almost primes.*/
     say N right(m,4)"-almost primes:" $ /*display the  k-almost primes.*/
     end       /*m*/                   /* [↑]  display a line for each K*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────#FACTR subroutine───────────────────*/
#factr: procedure;parse arg x 1 z; f=0 /*defines  X  and  Z  to the arg.*/
if x<2  then return 0                  /*invalid number?  Then return 0.*/
    do j=2  to 5;  if j\==4  then call .#factr;  end   /*fast factoring.*/
j=5                                    /*start were we left off  (J=5). */
    do y=0  by 2;  j=j+2 + y//4        /*insure it's not divisible by 3.*/
    if right(j,1)==5  then iterate     /*fast check  for divisible by 5.*/
    if j>z  then leave                 /*number reduced to a wee number?*/
    call .#factr                       /*go add other factors to count. */
    end   /*y*/                        /* [↑]  find all factors in  X.  */
return max(f,1)                        /*if prime (f==0), then return 1.*/
/*──────────────────────────────────.#FACTR subroutine──────────────────*/
.#factr:  do f=f+1  while  z//j==0     /*keep dividing until we can't.  */
          z=z%j                        /*perform an  (%) integer divide.*/
          end   /*while*/              /* [↑]  whittle down the  Z  num.*/
f=f-1                                  /*adjust the  count of factors.  */
return
