/*REXX pgm shows the states of a person's biorhythms (physical, emotional, intellectual)*/
parse arg birthdate targetDate .                 /*obtain one or two dates from the C.L.*/
days= daysbet2(birthdate targetDate)             /*invoke the 2nd version of a REXX pgm.*/
if days==0  then do;  say;   say 'The two dates specified are exacty the same.';   exit 1
                 end
cycles= 'physical  emotional  intellectual'      /*the   names of   each biorhythm cycle*/
cycle = 'negative neutral positive'              /* "   states of     "      "       "  */
@.1= 23;             @.2= 28;           @.3= 33  /* "  # of days in   "      "       "  */
pid2= pi() * 2 * days                            /*calculate  pi * t * number─of─days.  */

       do j=1  for 3
       state= 2   +   sign( sin( pid2 / @.j) )   /*obtain state for each biorhythm cycle*/
       say 'biorhythm for the'  right(word(cycles,j),12)   "cycle is"   word(cycle, state)
       end   /*j*/                               /* [↑]   get state for each biorhythm. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
pi:   pi= 3.1415926535897932384626433832795028841971693993751058209749445923078; return pi
r2r:  return arg(1)  //  (pi() * 2)              /*normalize radians ──► a unit circle. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sin:  procedure; parse arg x;  x= r2r(x);  _= x;  numeric fuzz min(5, max(1, digits() -3))
      if x=pi * .5         then return 1;         if x==pi*1.5  then return -1
      if abs(x)=pi | x=0   then return 0;         q= x*x;       z= x
        do k=2  by 2  until p=z;   p= z;   _= -_ *q/(k*k+k);    z= z+_;   end;    return z
