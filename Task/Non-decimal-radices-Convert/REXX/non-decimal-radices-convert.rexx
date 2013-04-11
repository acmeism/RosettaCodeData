/*REXX program converts numbers from one base to another, from 2 ──► 90.*/
/*┌────────────────────────────────────────────────────────────────────┐
┌─┘ Input to this program      (bases must be positive whole numbers): └─┐
│                                                                        │
│                          x       is required (it may have a sign).     │
│                        toBase    the base to convert   X   to.         │
│                        inBase    the base  X  is expressed in.         │
│                                                                        │
│  toBase   or   inBase    can be a comma (,)  which causes the default  │
└─┐    of  10  to be used.    The limits of bases are:    2 ──► 90.    ┌─┘
  └────────────────────────────────────────────────────────────────────┘*/
@abc='abcdefghijklmnopqrstuvwxyz'      /*lowercase Latin alphabet.      */
@abcU=@abc;  upper @abcU               /*go whole hog and extend 'em.   */
@@@=0123456789||@abc||@abcU            /*prefix 'em with numeric digits.*/
@@@=@@@'<>[]{}()?~!@#$%^&*_=|\/;:¢¬≈'  /*add some special chars as well.*/
                                       /*special chars must be viewable.*/
numeric digits 1000                    /*what da hey, support gihugeics.*/
maxB=length(@@@)                       /*max base (radix) supported here*/
parse arg x toB inB 1 ox .             /*get  a number,  toBase,  inBase*/
if toB=='' | toB==','  then toB=10     /*if skipped, assume default (10)*/
if inB=='' | inB==','  then inB=10     /* "    "        "      "      " */
if inB<2   | inb>maxB  then call erb 'inBase',inB      /*bad boy inBase.*/
if toB<2   | tob>maxB  then call erb 'toBase',toB      /* "   "  toBase.*/
if x==''               then call erm                   /* "   "  number.*/
sigX=left(x,1);  if pos(sigX,"-+")\==0  then x=substr(x,2) /*X has sign?*/
                                        else sigX=         /*no sign.   */
#=0;  do j=1  for length(x)            /*convert X, base inB ──► base 10*/
      _=substr(x,j,1)                  /*pick off a  "digit"  from  X.  */
      v=pos(_,@@@)                     /*get the value of this "digit". */
      if v==0 | v>inB  then call erd x,j,inB         /*illegal "digit"? */
      #=#*inB+v-1                      /*construct new num, dig by dig. */
      end        /*j*/

y=;     do  while # >= toB             /*convert #, base 10 ──► base toB*/
        y=substr(@@@,(#//toB)+1,1)y    /*construct the output number.   */
        #=#%toB                        /*... and whittle  #  down also. */
        end      /*while #>-toB*/

y=sigX || substr(@@@,#+1,1)y           /*prepend the sign if it existed.*/
say ox "(base" inB')' center('is',20) y "(base" toB')'    /*show & tell.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────error subroutines───────────────────*/
erb: call ser; say 'illegal' arg(2) "base:" arg(1) "must be in range: 2──►" maxB
erd: call ser; say 'illegal "digit" in' x":" _
erm: call ser; say 'no argument specified.'
ser: say; say '*** error! ***';     say;     exit 13
