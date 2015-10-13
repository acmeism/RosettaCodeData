/*REXX program computes & displays N numbers of the first  K  k─almost primes.*/
parse arg N K .                        /*get optional arguments from the C.L. */
if N==''  then N=10                    /*N  not specified?   Then use default.*/
if K==''  then K= 5;    w=length(k)    /*K   "      "          "   "     "    */
                                       /*W: is the width of K, used for output*/
    do m=1  for  K;     $=2**m;  fir=$ /*generate & assign 1st k─almost prime.*/
    #=1;         if #==N  then leave   /*#: k─almost primes; Enough are found?*/
    #=2;         $=$ 3*(2**(m-1))      /*generate & append 2nd k─almost prime.*/
        do j=fir+fir+1  until #==N     /*process an  almost-prime   N   times.*/
        if #factr(j)\==m  then iterate /*not the correct  k─almost  prime?    */
        #=#+1;   $=$ j                 /*bump K─almost counter; append it to $*/
        end   /*j*/                    /* [↑]   generate  N  k─almost  primes.*/
    say right(m,w)"─almost ("N') primes:' $    /*displays "  "    "       "   */
    end       /*m*/                    /* [↑]  display a line for each K-prime*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
#factr: procedure;  parse arg x 1 z    /*defines  X  and  Z  to the argument. */
                            do f=0  while z//2==0;  z=z%2;  end     /*÷ by 2s.*/
                            do f=f  while z//3==0;  z=z%3;  end     /*÷  " 3s.*/
                            do f=f  while z//5==0;  z=z%5;  end     /*÷  " 5s.*/
j=5
             do y=0  by 2;  j=j+2+y//4 /*insure  J  isn't divisible by three. */
             parse var  j   ''  -1  _  /*obtain the right─most decimal digit. */
             if _==5  then iterate     /*fast check  for divisible by five.   */
             if j>z   then leave       /*is number reduced to the smallest # ?*/
                do f=f+1  while z//j==0; z=z%j;  end;  f=f-1        /*÷ by Js.*/
             end   /*y*/               /* [↑]  find all the factors in  X.    */
return max(f,1)                        /*if  prime (f==0),  then  return 1.   */
