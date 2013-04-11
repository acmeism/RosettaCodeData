/*REXX pgm finds  LCM  (Least Common Multiple)  of a number of integers.*/
numeric digits 9000                    /*handle nine-thousand digit nums*/

say 'the LCM of  19  &   0            is:' lcm(19  0)
say 'the LCM of   0  &  85            is:' lcm( 0 85)
say 'the LCM of  14  &  -6            is:' lcm(14,-6)
say 'the LCM of  18  &  12            is:' lcm(18 12)
say 'the LCM of  18  &  12  & -5      is:' lcm(18 12,-5)
say 'the LCM of  18  &  12  & -5 & 97 is:' lcm(18,12,-5,97)
say 'the LCM of  2**19-1  &  2**521-1 is:' lcm(2**19-1  2**521-1)
                         /*──(above)── the 7th and 13th Mersenne primes.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────LCM subroutine──────────────────────*/
lcm:  procedure;  $=;                  do j=1  for arg(); $=$ arg(j);  end
x=abs(word($,1))                       /* [↑] build a list of arguments.*/
            do k=2  to words($);   !=abs(word($,k));  if !=0 then return 0
            x=x*! / gcd(x,!)           /*have  GCD do the heavy lifting.*/
            end   /*k*/
return x                               /*return with the money.         */
/*──────────────────────────────────GCD subroutine──────────────────────*/
gcd:  procedure;  $=;                  do j=1  for arg(); $=$ arg(j);  end
parse var $ x z .;   if x=0 then x=z   /* [↑] build a list of arguments.*/
x=abs(x)
            do k=2  to words($);    y=abs(word($,k));  if y=0 then iterate
              do until _==0;   _=x//y;   x=y;   y=_;   end   /*until*/
            end   /*k*/
return x                               /*return with the money.         */
