/*REXX program calculates and displays  Catalan numbers  using  four different methods. */
parse arg LO HI .                                /*obtain optional arguments from the CL*/
if LO=='' | LO==","  then do;  HI=15; LO=0;  end /*No args? Then use a range of 0 ──► 15*/
if HI=='' | HI==","  then      HI=LO             /*No HI?   Then use  LO for the default*/
numeric digits max(20, 5*HI)                     /*this allows gihugic Catalan numbers. */
w=length(HI)                                     /*W:  is used for aligning the output. */
call hdr 1A;  do j=LO  to HI;  say '     Catalan'     right(j, w)": "      Cat1A(j);   end
call hdr 1B;  do j=LO  to HI;  say '     Catalan'     right(j, w)": "      Cat1B(j);   end
call hdr 2 ;  do j=LO  to HI;  say '     Catalan'     right(j, w)": "      Cat2(j) ;   end
call hdr 3 ;  do j=LO  to HI;  say '     Catalan'     right(j, w)": "      Cat3(j) ;   end
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
!:     arg z; if !.z\==. then return !.z; !=1;  do k=2 for z; !=!*k; end;  !.z=!; return !
Cat1A: procedure expose !.;  parse arg n;     return comb(n+n, n)    %  (n+1)
Cat1B: procedure expose !.;  parse arg n;     return !(n+n) % ((n+1) * !(n)**2)
Cat3:  procedure expose c.;  arg n; if c.n==. then c.n=(4*n-2)*cat3(n-1)%(n+1); return c.n
comb:  procedure;            parse arg x,y;   return pFact(x-y+1, x) % pFact(2, y)
hdr:   !.=.; c.=.; c.0=1; say; say center('Catalan numbers, method' arg(1),79,'─'); return
pFact: procedure;            !=1;      do k=arg(1)  to arg(2);  !=!*k;  end;    return !
/*──────────────────────────────────────────────────────────────────────────────────────*/
Cat2:  procedure expose c.;  parse arg n;  $=0;          if c.n\==.  then return c.n
                                       do k=0  to n-1;   $=$ + cat2(k) * cat2(n-k-1);  end
                             c.n=$;           return $    /*use a memoization technique.*/
