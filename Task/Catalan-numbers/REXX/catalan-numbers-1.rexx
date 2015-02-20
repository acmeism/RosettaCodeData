/*REXX program calculates  Catalan numbers using four different methods.*/
parse arg bot top .                    /*get optional args from the C.L.*/
if bot=='' then do; top=15; bot=0; end /*No args? Use a range of 0──►15.*/
if top=='' then top=bot                /*No top?  Use the bottom for it.*/
numeric digits max(20, 5*top)          /*allows gihugic Catalan numbers.*/
call hdr '1a';     do j=bot  to top;     say $cat() catalan1a(j);      end
call hdr '1b';     do j=bot  to top;     say $cat() catalan1b(j);      end
call hdr  2  ;     do j=bot  to top;     say $cat() catalan2(j) ;      end
call hdr  3  ;     do j=bot  to top;     say $cat() catalan3(j) ;      end
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─liner subroutines───────────────*/
$cat:      return  '     Catalan'  right(j,length(top))": "
catalan1a: procedure expose !.; parse arg n; return comb(n+n,n)%(n+1)
catalan1b: procedure expose !.; parse arg n; return !(n+n)%((n+1)*!(n)**2)
comb:      procedure; parse arg x,y;   return  pFact(x-y+1,x) % pFact(2,y)
pFact:     procedure; !=1;  do k=arg(1)  to arg(2); !=!*k; end;   return !
/*──────────────────────────────────! (factorial) function──────────────*/
!:         procedure expose !.;  parse arg x;   if !.x\==. then return !.x
!=1;            do k=1  for x; !=!*k;  end  /*k*/;     !.x=!;   return !
/*──────────────────────────────────catalan method 2────────────────────*/
catalan2:  procedure expose c.;  parse arg n;  if c.n\==.  then return c.n
s=0;            do k=0  to  n-1
                s=s + catalan2(k) * catalan2(n-k-1)  /*recursive invokes*/
                end   /*k*/
c.n=s; return s                        /*use REXX memoization technique.*/
/*──────────────────────────────────catalan method 3────────────────────*/
catalan3: procedure expose c.;  parse arg n;   if c.n\==.  then return c.n
c.n=(4*n-2) * catalan3(n-1) % (n+1);   return c.n     /*use memoization.*/
/*──────────────────────────────────HDR subroutine──────────────────────*/
hdr:  !.=.;    c.=.;    c.0=1;    say  /*set some variables; blank line.*/
say center(' Catalan numbers, method' left(arg(1),3), 79, '─');     return
