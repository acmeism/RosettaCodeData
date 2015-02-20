/*REXX program to generate and display a number of narcissistic numbers.*/
numeric digits 39                      /*be able to handle the largest #*/
parse arg N .;   if N==''  then N=25   /*get number of narcissistic #'s.*/
N=min(N,89)                            /*there are  89  narcissistic #s.*/
#=0                                    /*number of narcissistic # so far*/
     do j=0  until #==N;   L=length(j) /*get the length of the J number.*/
     s=left(j,1)**L                    /*1st digit in J raised to L pow.*/
            do k=2  for L-1  until s>j /*perform for each digit in  J.  */
            s=s + substr(j,k,1)**L     /*add digit raised to pow to sum.*/
            end   /*k*/                /* [↑]  calculate the rest of sum*/
     if s\==j  then iterate            /*does sum equal to  J?   No ··· */
     #=#+1                             /*bump the narcissistic num count*/
     say right(#,9) ' narcissistic:' j /*display index & narcissistic #.*/
     end   /*j*/                       /* [↑]    this list starts at 0. */
                                       /*stick a fork in it, we're done.*/
