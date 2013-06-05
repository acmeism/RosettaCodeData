/*REXX pgm displays Floyd's triangle for any  # of rows  up to base  99.*/
parse arg rows b .; if rows==''  then rows=5 /*use 5 rows if not given. */
if b=='' then b=10                           /*use base 10 if not given.*/
mV = rows * (rows+1) % 2                     /*calculate the max value. */
say 'displaying a'  rows  "row Floyd's triangle in base" b':';        say
#=1;              do     r=1  for rows;   i=0;       _=''
                      do #=#  for r;      i=i+1
                      _ = _ right(base(#, b),  length(base(mV-rows+i, b)))
                      end   /*#*/
                  say _
                  end       /*r*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BASE subroutine─────────────────────*/
base: procedure; parse arg x 1 ox,toB,inB /*get a number, toBase, inBase*/
@abc='abcdefghijklmnopqrstuvwxyz'      /*lowercase Latin alphabet.      */
@abcU=@abc;  upper @abcU               /*go whole hog and extend 'em.   */
@@@=0123456789||@abc||@abcU            /*prefix 'em with numeric digits.*/
@@@=@@@'<>[]{}()?~!@#$%^&*_=|\/;:¢¬≈'  /*add some special chars as well.*/
               /*handles up to base 99,  special chars must be viewable.*/
numeric digits 1000                    /*what da hey, support gihugeics.*/
maxB=length(@@@)                       /*max base (radix) supported here*/
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
return y                               /*rturn the number in base  toB. */
/*──────────────────────────────────error subroutines───────────────────*/
erb: call ser; say 'illegal' arg(2) "base:" arg(1) "must be in range: 2──►" maxB
erd: call ser; say 'illegal "digit" in' x":" _
erm: call ser; say 'no argument specified.'
ser: say; say '*** error! ***';     say;     exit 13
