/*REXX pgm converts any integer (or a range) to a van der Corput number in base 2,*/
/*                  or optionaly, any other base up to base 90.         */
/*If the base is negative, the output is shown as a list.               */

numeric digits 1000                    /*handle anything the user wants.*/
parse arg a b r .                      /*obtain the number(s)  [maybe]. */
if a=='' then do;  a=0;  b=10;  end    /*if none specified, use defaults*/
if b=='' then b=a                      /*assume a "range" of a single #.*/
if r=='' then r=2                      /*assume a radix (base) of  2.   */
z=                                     /*placeholder for a list of nums.*/

      do j=a to b                      /*traipse through the range.     */
      _=vdC(abs(j),abs(r))             /*convert abs value of integer.  */
      _=substr('-',2+sign(j))_         /*if needed, leading minus sign. */
      if r>0 then say _                /*if positive base, just show it.*/
             else z=z _                /*        ... else build a list. */
      end   /*j*/

if z\=='' then say strip(z)            /*if list wanted, then show it.  */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────VDC [van der Corput] subroutine─────*/
vdC: return '.'reverse(base(arg(1),arg(2)))  /*convert, reverse, append.*/
/*──────────────────────────────────BASE subroutine (up to base 90)─────*/
base: procedure; parse arg x,toB,inB   /*get a number,  toBase,  inBase */

/*┌────────────────────────────────────────────────────────────────────┐
┌─┘ Input to this subroutine    (all must be positive whole numbers):  └─┐
│                                                                        │
│                          x       (is required).                        │
│                        toBase    the base to convert   X   to.         │
│                        inBase    the base  X  is expressed in.         │
│                                                                        │
│   toBase  or  inBase    can be omitted   which causes the default of   │
└─┐        10  to be used.   The limits of both are:    2 ──► 90.      ┌─┘
  └────────────────────────────────────────────────────────────────────┘*/

@abc='abcdefghijklmnopqrstuvwxyz'      /*random characters, sorted.     */
@abcU=@abc; upper @abcU                /*go whole hog and extend 'em.   */
@@@=0123456789||@abc||@abcU            /*prefix 'em with numeric digits.*/
@@@=@@@'<>[]{}()?~!@#$%^&*_+-=|\/;:~'  /*add some special chars as well.*/
                                       /*spec. chars should be viewable.*/
numeric digits 1000                    /*what the hey, support biggies. */
maxB=length(@@@)                       /*max base (radix) supported here*/
parse arg x,toB,inB                    /*get a number, toBase, inBase   */
if toB=='' then toB=10                 /*if skipped, assume default (10)*/
if inB=='' then inB=10                 /* "    "        "      "      " */

/*══════════════════════════════════convert X from base inB ──► base 10.*/
#=0
      do j=1 for length(x)
      _=substr(x,j,1)                  /*pick off a "digit" from X.     */
      v=pos(_,@@@)                     /*get the value of this "digits".*/
      if v==0 |v>inB then call erd x,j,inB           /*illegal "digit"? */
      #=#*inB+v-1                      /*construct new num, dig by dig. */
      end   /*j*/

/*══════════════════════════════════convert # from base 10 ──► base toB.*/
y=
        do while #>=toB                /*deconstruct the new number (#).*/
        y=substr(@@@,(#//toB)+1,1)y    /*construnct the output number.  */
        #=#%toB                        /*... and whittle  #  down also. */
        end   /*while*/

return substr(@@@,#+1,1)y
