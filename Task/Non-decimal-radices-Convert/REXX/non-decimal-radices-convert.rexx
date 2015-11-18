/*REXX pgm converts integers from one base to another  (base 2 ──► 90). */
@abc  = 'abcdefghijklmnopqrstuvwxyz'   /*the lowercase (Latin) alphabet.*/
parse  upper  var  @abc    @abcU       /*uppercase a version of  @abc.  */
@@ = 0123456789 || @abc || @abcU       /*prefix 'em with numeric digits.*/
@@ = @@'<>[]{}()?~!@#$%^&*_=|\/;:¢¬≈'  /*add some special chars as well.*/
                                       /* [↑] all chars must be viewable*/
numeric digits 3000                    /*what da hey, support gihugeics.*/
maxB=length(@@)                        /*max base (radix) supported here*/
parse arg x toB inB 1 ox . 1 sigX 2 x2 .   /*get: 3 args, origX, sign···*/
if pos(sigX,"+-")\==0  then x=x2       /*Does  X  have a leading sign?  */
                       else sigX=      /*Nope.  No leading sign for  X. */
if x==''               then call erm   /*if no  X  number,  issue error.*/
if toB=='' | toB==","  then toB=10     /*if skipped, assume default (10)*/
if inB=='' | inB==","  then inB=10     /* "    "        "      "      " */
if inB<2   | inb>maxB  | \datatype(inB,'W')  then call erb  'inBase '  inB
if toB<2   | toB>maxB  | \datatype(toB,'W')  then call erb  'toBase '  toB
#=0                                    /*result of converted X (base 10)*/
      do j=1  for length(x)            /*convert X, base inB ──► base 10*/
      ?=substr(x,j,1)                  /*pick off a numeral/digit from X*/
      _=pos(?, @@)                     /*calculate this numeral's value.*/
      if _==0 | _>inB  then call erd x /*_ character an illegal numeral?*/
      #=#*inB+_-1                      /*build a new number, dig by dig.*/
      end    /*j*/                     /* [↑]  this also verifies digits*/
y=                                     /*the value of  X  in  base  B.  */
      do  while  # >= toB              /*convert #, base 10 ──► base toB*/
      y=substr(@@, (#//toB)+1, 1)y     /*construct the output number.   */
      #=#%toB                          /*··· and whittle  #  down also. */
      end    /*while*/                 /* [↑]  process leaves a residual*/
                                       /* [↓]         Y  is the residual*/
y=sigX || substr(@@, #+1, 1)y          /*prepend the sign if it existed.*/
say ox  "(base"      inB')'       center('is',20)     y     "(base" toB')'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─liner subroutines───────────────*/
erb: call ser 'illegal' arg(1)",  it must be in the range:  2──►"maxB
erd: call ser 'illegal digit/numeral  ['?"]  in:  "       x
erm: call ser 'no argument specified.'
ser: say; say '***error!***';          say arg(1);               exit 13
