/*REXX program calculates  Carmichael  3-strong  pseudoprimes (up to N).*/
numeric digits 30                      /*in case user wants bigger nums.*/
parse arg N .;  if N=='' then N=61     /*allow user to specify the limit*/
if 1=='f1'x  then times='af'x          /*if EBCDIC machine, use a bullet*/
             else times='f9'x          /* " ASCII     "      "  "   "   */
carms=0                                /*number of Carmichael #s so far.*/
!.=0                                   /*a method of prime memoization. */
                                       /*Carmichael numbers aren't even.*/
    do p=3  to N  by 2;  if \isPrime(p) then iterate  /*Not prime? Skip.*/
    pm=p-1; nps=-p*p; @.=0; min=1e9; max=0 /*some handy-dandy variables.*/

             do h3=2  to  pm;  g=h3+p  /*find Carmichael #s for this P. */
               do d=1  to g-1
               if g*pm//d\==0                 then iterate
               if ((nps//h3)+h3)//h3\==d//h3  then iterate
               q=1+pm*g%d;    if \isPrime(q)  then iterate
               r=1+p*q%h3;    if q*r//pm\==1  then iterate
                              if \isPrime(r)  then iterate
               carms=carms+1           /*bump the Carmichael # counter. */
               min=min(min,q);  max=max(max,q);  @.q=r   /*build a list.*/
               end   /*d*/
             end     /*h3*/
                                       /*display a list of some Carm #s.*/
         do j=min to max by 2; if @.j==0 then iterate   /*one of the #s?*/
         say '──────── a Carmichael number: '   p   times  j   times   @.j
         end   /*j*/
    say                                /*show bueatification blank line.*/
    end        /*p*/

say;     say carms ' Carmichael numbers found.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPRIME subroutine──────────────────*/
isPrime: procedure expose !.;  parse arg x;  if !.x   then return 1
if wordpos(x,'2 3 5 7 11 13')\==0   then  do;  !.x=1;  return 1;  end
if x<17 then return 0;  if x//2==0 then return 0; if x//3==0 then return 0
if right(x,1)==5 then return 0; if x//7==0 then return 0
                 do i=11 by 6  until i*i>x;  if x// i    ==0 then return 0
                                             if x//(i+2) ==0 then return 0
                 end  /*i*/
!.x=1;  return 1
