/*REXX program computes the average loop length mapping a random field 1···N ───► 1···N */
parse arg runs tests seed .                      /*obtain optional arguments from the CL*/
if  runs =='' |  runs ==","  then runs =      40 /*Not specified?  Then use the default.*/
if tests =='' | tests ==","  then tests= 1000000 /* "      "         "   "   "     "    */
if datatype(seed,'W')   then call random ,, seed /*Is integer?   For RAND repeatability.*/
!.=0;          !.0=1                             /*used for  factorial (!)  memoization.*/
numeric digits 100000                            /*be able to calculate 25k! if need be.*/
numeric digits max(9, length( !(runs) )   )      /*set the NUMERIC DIGITS for  !(runs). */
say right(     runs, 24)      'runs'             /*display number of runs   we're using.*/
say right(    tests, 24)      'tests'            /*   "       "    " tests    "     "   */
say right( digits(), 24)      'digits'           /*   "       "    " digits   "     "   */
say
say "        N    average     exact     % error "     /* ◄─── title, header ►────────┐  */
hdr="       ═══  ═════════  ═════════  ═════════";       pad=left('',3)  /* ◄────────┘  */
say hdr
         do #=1  for runs;   av=fmtD( exact(#) ) /*use four digits past decimal point.  */
                             xa=fmtD( exper(#) ) /* "    "    "      "     "      "     */
         say right(#,9)  pad xa pad av pad fmtD( abs(xa-av) * 100 / av)   /*show values.*/
         end   /*#*/
say hdr                                          /*display the final header (some bars).*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
!:     procedure expose !.;  parse arg z;                      if !.z\==0  then return !.z
       !=1;       do j=2  for z -1;  !=!*j;  !.j=!;  end; /*compute factorial*/   return !
/*──────────────────────────────────────────────────────────────────────────────────────*/
exact: parse arg x;  s=0;     do j=1  for x;  s=s + !(x) / !(x-j) / x**j;  end;   return s
/*──────────────────────────────────────────────────────────────────────────────────────*/
exper: parse arg n;  k=0;     do tests;   $.=0                      /*do it TESTS times.*/
                                 do n;    r=random(1, n);      if $.r  then leave
                                 $.r=1;   k=k + 1                   /*bump the counter. */
                                 end   /*n*/
                              end      /*tests*/
       return k/tests
/*──────────────────────────────────────────────────────────────────────────────────────*/
fmtD:  parse arg y,d;     d=word(d 4, 1);    y=format(y, , d);     parse var  y  w  '.'  f
       if f=0  then return  w || left('', d +1);                                  return y
