/*REXX program displays the specified first (lowest) taxicab numbers (for three ranges).*/
parse arg  L.1  H.1      L.2 H.2      L.3 H.3 .  /*obtain optional arguments from the CL*/
   if L.1=='' | L.1==","  then L.1=   1          /*L1  is the low  part of 1st range.   */
   if H.1=='' | H.1==","  then H.1=  25          /*H1   "  "  high   "   "  "    "      */
   if L.2=='' | L.2==","  then L.2= 454          /*L2   "  "  low    "   " 2nd   "      */
   if H.2=='' | H.2==","  then H.2= 456          /*H2   "  "  high   "   "  "    "      */
   if L.3=='' | L.3==","  then L.3=2000          /*L3   "  "  low    "   " 3rd   "      */
   if H.3=='' | H.3==","  then H.3=2006          /*H3   "  "  high   "   "  "    "      */
mx= max(H.1,    H.2,    H.3)                     /*find how many taxicab numbers needed.*/
mx= mx   + mx % 10                               /*cushion;  compensate for the triples.*/
ww= length(mx) * 3;           w= ww % 2          /*widths used for formatting the output*/
numeric digits max(9, ww)                        /*prepare to use some larger numbers.  */
@.=.;    #= 0;     @@.= 0;    @and= "  ──and── " /*set some REXX vars and handy literals*/
$.=                                              /* [↓]  generate extra taxicab numbers.*/
    do j=1  until #>=mx;            C= j**3      /*taxicab numbers may not be in order. */
    !.j= C                                       /*use memoization for cube calculation.*/
      do k=1  for j-1;              s= C + !.k   /*define a whole bunch of cube sums.   */
      if @.s==.  then do;  @.s= j;  b.s= k       /*Cube not defined?   Then process it. */
                           iterate               /*define  @.S  and  B.S≡sum  of 2 cubes*/
                      end                        /* [↑]  define one cube sum at a time. */
      has= @@.s                                  /*has this number been defined before? */
      if has  then $.s= $.s @and U(j,'   +')U(k) /* ◄─ build a display string. [↓]      */
              else $.s= right(s,ww)  '───►'   U(@.s,"   +")U(b.s)   @and   U(j,'   +')U(k)
      @@.s= 1                                    /*mark taxicab number as a sum of cubes*/
      if has   then iterate                      /*S  is a triple (or sometimes better).*/
      #= # + 1;    #.#= s                        /*bump taxicab counter; define taxicab#*/
      end   /*k*/                                /* [↑]  build the cubes one─at─a─time. */
    end      /*j*/                               /* [↑]  complete with overage numbers. */
A.=
       do k=1  for mx;   _= #.k;    A.k= $._     /*re─assign disjoint $. elements to A. */
       end   /*k*/
call Esort  mx                                   /*sort taxicab #s with an exchange sort*/
       do grp=1  for 3;  call tell L.grp, H.grp  /*display the three grps of numbers. */
       end   /*grp*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:  do t=arg(1)  to arg(2);    say right(t, 9)':'   A.t;     end;        say;    return
U:     return right(arg(1), w)'^3'arg(2)         /*right─justify a number,  append "^3" */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Esort: procedure expose A.; parse arg N;         h= N    /*Esort when items have blanks.*/
         do  while h>1;     h= h % 2
           do i=1  for N-h;           k=h + i;   j= i
              do forever;   parse var A.k xk .;  parse var A.j xj .;  if xk>=xj then leave
              _= A.j;       A.j= A.k; A.k= _             /*swap two elements of A. array*/
              if h>=j  then leave;    j=j - h;   k= k - h
              end   /*forever*/
           end      /*i*/
         end        /*while h>1*/;               return
