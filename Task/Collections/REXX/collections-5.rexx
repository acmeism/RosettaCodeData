pr.=0        /*define a default for all elements for the stemmed array.*/
pr.2 =1
pr.3 =1
pr.5 =1
pr.7 =1
pr.11=1
pr.13=1
pr.17=1
pr.19=1
pr.23=1
pr.29=1
pr.31=1
pr.37=1
pr.41=1
pr.43=1
/*─────────────────────────────────────────────────────────────────────*/
primes=0
           do j=1  for 10000         /*this method isn't very efficient*/
           if pr.j==0  then iterate
           primes = primes+1
           end   /*j*/

say '# of primes in list:' primes
/*─────────────────────────────────────────────────────────────────────*/
#primes=0
           do j=1  for 10000         /*this method isn't very efficient*/
           if pr.j\==0  then #primes = #primes+1
           end   /*j*/

say '# of primes in list:' #primes
/*─────────────────────────────────────────────────────────────────────*/
s=0                                  /*yet another inefficient method. */
           do k=1  for 10000         /*this method isn't very efficient*/
           Ps = Ps + (pn.k\==0)      /*more obtuse, if ya like that.   */
           say 'prime' Ps "is:" k    /*might as well echo the prime #. */
           end   /*k*/

say 'number of primes found in the list is' Ps
