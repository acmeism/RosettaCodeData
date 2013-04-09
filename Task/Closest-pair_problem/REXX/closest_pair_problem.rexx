/*REXX program to solve the  closest pair problem.                      */
parse arg N low high seed .;  if n=='' then n=100
if seed\=='' then call random ,,seed   /*use seed, makes rand repeatable*/
if  low=='' |  low==','   then   low=0
if high=='' | high==','   then  high=20000
w=length(high);    w=w + (w//2==0)
                                    do j=1  for N    /*gen random points*/
                                    @.j.xx=random(low,high)
                                    @.j.yy=random(low,high)
                                    end   /*j*/
nearA=1
nearB=2
minDD=(@.nearA.xx-@.nearB.xx)**2 + (@.nearA.yy-@.nearB.yy)**2

                       do   j=1  for N-1
                         do k=j+1  to N
                         dd=(@.j.xx-@.k.xx)**2 + (@.j.yy-@.k.yy)**2
                         if dd\=0 then  if dd<minDD  then do;   minDD=dd
                                                          nearA=j
                                                          nearB=k
                                                          end
                         end   /*k*/
                       end     /*j*/

say 'For' N "points:";   say
say '                 'center('x',w,"â")' ' center('y',w,"â")
say 'The points      ['right(@.nearA.xx,w)"," right(@.nearA.yy,w)"]" '  and'
say '                ['right(@.nearB.xx,w)"," right(@.nearB.yy,w)"]";  say
say 'the minimum distance between them is: '    sqrt(abs(minDD))
exit                                   /*stick a fork in it, we're done.*/
/*âââââââââââââââââââââââââââââââââââsqrt subroutineââââââââââââââââââââ*/
sqrt: procedure; parse arg x; if x=0 then return 0;d=digits();numeric digits 11
      g=.sqrtG();             do j=0  while p>9;  m.j=p;  p=p%2+1;   end
      do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k; g=.5*(g+x/g); end
      numeric digits d;  return g/1
.sqrtG:  numeric form;   m.=11;   p=d+d%4+2
         parse value format(x,2,1,,0) 'E0' with g 'E' _ .;   return g*.5'E'_%2
