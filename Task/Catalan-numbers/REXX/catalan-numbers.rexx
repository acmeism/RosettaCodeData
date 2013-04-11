/*REXX program calculates Catalan numbers using three different methods.*/
parse arg bot top .                    /*get args from the command line.*/
if bot=='' then do; top=15; bot=0; end /*No args? Use a range of 0 ─► 15*/
if top=='' then top=bot                /*No top?  Use the bottom for it.*/
numeric digits max(20,5*top)           /*no limit on big Catalan numbers*/
w=length(top)                          /*use  W  to align Catalan index.*/

say;  say center(' Catalan numbers, method 1 ' , 79, '-');    !.=0
                          do m1=bot  to top
                          say right(m1,w)  '='  catalan1(m1)
                          end     /*m1*/

say;  say center(' Catalan numbers, method 2 ' , 79, '-');    c.=0;  c.0=1
                          do m2=bot  to top
                          say right(m2,w)  '='  catalan2(m2)
                          end     /*m2*/

say;  say center(' Catalan numbers, method 3 ' , 79, '-');    c.=0;  c.0=1
                          do m3=bot  to top
                          say right(m3,w)  '='  catalan3(m3)
                          end     /*m3*/
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────catalan method 1────────────────────*/
catalan1: procedure expose !.; parse arg n  /*n+n  is faster than  2*n  */
return !(n+n)  %    ( (n+1)  *  !(n)**2 )   /*using COMB would be faster*/

/*──────────────────────────────────catalan method 2────────────────────*/
catalan2: procedure expose c.; parse arg n; if c.n\==0 then return c.n
s=0;     do j=0  to  n-1
         s=s   +   catalan2(j) * catalan2(n-j-1)    /*recursive invokes.*/
         end   /*j*/
c.n=s                                  /*use REXX memoization technique.*/
return s

/*──────────────────────────────────catalan method 3────────────────────*/
catalan3: procedure expose c.; parse arg n;  if c.n\==0 then return c.n
c.n=(4*n-2) * catalan3(n-1) % (n+1)    /*use REXX memoization technique.*/
return c.n

/*──────────────────────────────────! (factorial) function──────────────*/
!: procedure expose !.;   parse arg x;   if !.x\==0 then return !.x;   !=1
            do k=1  for x
            !=!*k
            end   /*k*/
!.x=!                                  /*use REXX memoization technique.*/
return !
