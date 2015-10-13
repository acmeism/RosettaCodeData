/*REXX program calculates  Catalan numbers  using four different methods.     */
parse arg bot top .                    /*get optional arguments from the C.L. */
if bot=='' then do; top=15; bot=0; end /*No args?  Use a range of  0 ───► 15. */
if top=='' then top=bot                /*No top?  Use the bottom for default. */
numeric digits max(20, 5*top)          /*this allows gihugic Catalan numbers. */
@cat='     Catalan'                    /*a nice literal to have for the  SAY. */
w=length(top)                          /*width of the largest number for SAY. */
call hdr 1A;   do j=bot  to top;   say @cat  right(j,w)": "  Catalan1A(j);   end
call hdr 1B;   do j=bot  to top;   say @cat  right(j,w)": "  Catalan1B(j);   end
call hdr 2 ;   do j=bot  to top;   say @cat  right(j,w)": "  Catalan2(j);    end
call hdr 3 ;   do j=bot  to top;   say @cat  right(j,w)": "  Catalan3(j);    end
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
Catalan1A: procedure expose !.; parse arg n;  return comb(n+n, n)    %  (n+1)
Catalan1B: procedure expose !.; parse arg n;  return !(n+n) % ((n+1) * !(n)**2)
comb:      procedure; parse arg x,y;          return pFact(x-y+1,x) % pFact(2,y)
pFact:     procedure; !=1;      do k=arg(1)  to arg(2);  !=!*k;  end;   return !
/*────────────────────────────────────────────────────────────────────────────*/
hdr:  !.=.;    c.=.;    c.0=1;    say
say center(' Catalan numbers, method' left(arg(1),3), 79, '─');     return
/*────────────────────────────────────────────────────────────────────────────*/
!:         procedure expose !.;  parse arg x;  !=1;  if !.x\==.  then return !.x
                           do k=1  for x;  !=!*k;  end  /*k*/
           !.x=!; return !
/*──────────────────────────────────Catalan method 2──────────────────────────*/
Catalan2:  procedure expose c.;  parse arg n;  $=0;  if c.n\==.  then return c.n
                           do k=0  to n-1; $=$+catalan2(k)*catalan2(n-k-1);  end
           c.n=$; return $             /*use a REXX memoization technique.    */
/*──────────────────────────────────Catalan method 3──────────────────────────*/
Catalan3:  procedure expose c.;   parse arg n
           if c.n==.  then c.n=(4*n-2) * catalan3(n-1) % (n+1);       return c.n
