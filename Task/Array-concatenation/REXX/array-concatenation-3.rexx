/*REXX program to demonstrates how to perform array concatenation.*/

p.=                                    /*(below) a short list of primes.*/
p.1=2;    p.2=3;     p.3=5;     p.4=7;     p.5=11;   p.6=13
p.7=17;   p.8=19;    p.9=23;    p.10=27;   p.11=31;  p.12=37

f.=                                    /*(below) a list of Fibonacci #s.*/
f.0=0;f.1=1;f.2=1;f.3=2;f.4=3;f.5=5;f.6=8;f.7=13;f.8=21;f.9=34;f.10=55

             do j=1  while p.j\==''
             c.j=p.j                   /*assign C array with some primes*/
             end   /*j*/
n=j-1
             do k=0  while f.k\=='';   n=n+1
             c.n=f.k                   /*assign C array with fib numbers*/
             end   /*k*/
say 'elements=' n
say
             do m=1  for n
             say 'c.'m"="c.m           /*show a "merged"  C  array nums.*/
             end   /*m*/
                                       /*stick a fork in it, we're done.*/
