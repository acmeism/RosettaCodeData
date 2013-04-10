/*REXX program to read a config file and assign VARs as found within.   */
numeric digits 10000                   /*be able to calculate  !(runs). */
parse arg runs tests seed .
if  runs ==','  |   runs ==''  then runs  =      40     /*num of runs.  */
if tests ==','  |  tests ==''  then tests = 1000000     /*num of trials.*/
if  seed\==','  &   seed\==''  then call random ,,seed  /*repeatability?*/
numeric digits max(9,length(!(runs)))  /*set NUMERIC digits for !(runs).*/
say right(     runs, 24)  'runs'       /*display # of runs   we're using*/
say right(    tests, 24)  'tests'      /*   "    "  " tests    "     "  */
say right( digits(), 24)  'digits'     /*   "    "  " digits   "     "  */
say
say '        N    average     exact     % error'        /*headers & pad.*/
h=  '       ───  ─────────  ─────────  ─────────'; say h;   pad=left('',3)

      do #=1  for runs;  ##=right(#,9) /*## is used for indenting output*/
        a= format(exact(#)       ,,4)  /*use 4 digits past decimal point*/
        e= format(exper(#)       ,,4)  /* "  "    "     "     "      "  */
      err= format(abs(e-a)*100/a ,,4)  /* "  "    "     "     "      "  */
      if err=0  then err=err/1         /*present a clean & concise zero.*/
      say ##  pad  e  pad  a  pad  err /*display a line of statistics.  */
      end   /*#*/
say h                                  /*display the final header bar.  */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────! subroutine────────────────────────*/
!: procedure; !=1;      do j=2  to arg(1);   !=!*j;   end;        return !
/*──────────────────────────────────EXACT subroutine────────────────────*/
exact: parse arg x; s=0; do j=1 for x; s=s+!(x)/!(x-j)/x**j; end; return s
/*──────────────────────────────────EXPER subroutine────────────────────*/
exper: parse arg n
k=0;                do tests;  !.=0    /*repeat TESTS times, reset found*/
                    !.=0               /*stemmed array: expected results*/
                        do n;     r=random(1,n);        if !.r  then leave
                        !.r=1;    k=k+1                 /*bump the ctr. */
                        end   /*n*/
                    end       /*tests*/
return k/tests
