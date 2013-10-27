/*REXX pgmm computes avg loop length mapping a random field 1..N to 1..N*/
parse arg runs tests seed .
if  runs ==','  |   runs ==''  then runs  =      40     /*num of runs.  */
if tests ==','  |  tests ==''  then tests = 1000000     /*num of trials.*/
if  seed\==','  &   seed\==''  then call random ,,seed  /*repeatability?*/
numeric digits 100000;  !.=0;  !.0=1   /*be able to calculate  !(25000).*/
numeric digits max(9,length(!(runs)))  /*set NUMERIC digits for !(runs).*/
say right(     runs, 24)  'runs'       /*display # of runs   we're using*/
say right(    tests, 24)  'tests'      /*   "    "  " tests    "     "  */
say right( digits(), 24)  'digits'     /*   "    "  " digits   "     "  */
say
say '        N    average     exact     % error'        /*headers & pad.*/
h=  '       ───  ─────────  ─────────  ─────────';  say h;  pad=left('',3)

      do #=1  for runs;  ##=right(#,9) /*## is used for indenting output*/
      avg = fmtD(exact(#))             /*use 4 digits past decimal point*/
      exa = fmtD(exper(#))             /* "  "    "     "     "      "  */
      err = fmtD(abs(exa-avg)*100/avg) /* "  "    "     "     "      "  */
      say ## pad exa pad avg pad err   /*display a line of statistics.  */
      end   /*#*/
say h                                  /*display the final header bar.  */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────! subroutine────────────────────────*/
!: procedure expose !.;  parse arg z;          if !.z\==0  then return !.z
!=1;   do j=1  for z;    !=!*j; !.j=!;    end;                  return !
/*──────────────────────────────────EXACT subroutine────────────────────*/
exact: parse arg x; s=0; do j=1 for x; s=s+!(x)/!(x-j)/x**j; end; return s
/*──────────────────────────────────EXPER subroutine────────────────────*/
exper: parse arg n
k=0;                do tests;  $.=0    /*repeat TESTS times, reset FOUND*/
                        do n;     r=random(1,n);        if $.r  then leave
                        $.r=1;    k=k+1                 /*bump the ctr. */
                        end   /*n*/
                    end       /*tests*/
return k/tests
/*──────────────────────────────────FMTD subroutine─────────────────────*/
fmtD: parse arg y,d;  d=word(d 4,1);   y=format(y,,d); parse var y w '.' f
if f=0  then return w || left('',d+1); return y
