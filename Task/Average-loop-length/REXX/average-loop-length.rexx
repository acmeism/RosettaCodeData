/*REXX pgm computes average loop length mapping a random field 1..N ───► 1..N */
parse arg runs tests seed .            /*obtain optional arguments from C.L.  */
if  runs ==','  |   runs ==''  then runs =      40       /*number of runs.    */
if tests ==','  |  tests ==''  then tests= 1000000       /*   "    " trials.  */
if  seed\==','  &   seed\==''  then call random ,,seed   /*RAND repeatability?*/
numeric digits 100000;  !.=0;  !.0=1   /*be able to calculate  25,000!        */
numeric digits max(9,length(!(runs)))  /*set the NUMERIC DIGITS for  !(runs). */
say right(     runs, 24)  'runs'       /*display number of runs   we're using.*/
say right(    tests, 24)  'tests'      /*   "       "    " tests    "     "   */
say right( digits(), 24)  'digits'     /*   "       "    " digits   "     "   */
say
say '        N    average     exact     % error'        /*◄──title,header►───┐*/
h=  '       ───  ─────────  ─────────  ─────────';  pad=left('',3)  /*◄──────┘*/
say h
       do #=1  for runs; ##=right(#,9) /*##  is used for indenting the output.*/
       avg=fmtD(exact(#))              /*use four digits past decimal point.  */
       exa=fmtD(exper(#))              /* "    "    "      "     "      "     */
       err=fmtD(abs(exa-avg)*100/avg)  /* "    "    "      "     "      "     */
       say ## pad exa pad avg pad err  /*display a line of statistics to term.*/
       end   /*#*/
say h                                  /*display the final header (some bars).*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
!:     procedure expose !.;  parse arg z;            if !.z\==0  then return !.z
       !=1;   do j=1  for z;  !=!*j;  !.j=!;  end;   /*factorial*/    return !
/*────────────────────────────────────────────────────────────────────────────*/
exact: parse arg x; s=0;     do j=1 for x; s=s+!(x)/!(x-j)/x**j; end; return s
/*────────────────────────────────────────────────────────────────────────────*/
exper: parse arg n; k=0;     do tests; $.=0               /*do it TESTS times.*/
                                 do n;   r=random(1,n);  if $.r  then leave
                                 $.r=1;  k=k+1            /*bump the counter. */
                                 end   /*n*/
                             end       /*tests*/
       return k/tests
/*────────────────────────────────────────────────────────────────────────────*/
fmtD:  parse arg y,d;   d=word(d 4,1);   y=format(y,,d);    parse var  y w '.' f
       if f=0  then return  w || left('', d+1);             return y
