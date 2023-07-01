/*REXX pgm converts an integer (or a range) ──► a Van der Corput number,  in base 2, or */
/*────────────────────────────── optionally, any other base up to and including base 90.*/
numeric digits 1000                              /*handle almost anything the user wants*/
parse arg a b r .                                /*obtain optional arguments from the CL*/
if a=='' | a=="," then parse value 0 10 with a b /*Not specified?  Then use the defaults*/
if b=='' | b=="," then b= a                      /* "      "         "   "   "      "   */
if r=='' | r=="," then r= 2                      /* "      "         "   "   "      "   */
z=                                               /*a placeholder for a list of numbers. */
                do j=a  to b                     /*traipse through the range of integers*/
                _= VdC( abs(j), abs(r) )         /*convert the ABSolute value of integer*/
                _= substr('-',  2 + sign(j) )_   /*if needed, keep the leading  -  sign.*/
                if r>0  then say _               /*if positive base, then just show it. */
                        else z=z _               /*     ··· else append (build) a list. */
                end   /*j*/

if z\==''  then say strip(z)                     /*if a list is wanted, then display it.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
base: procedure; parse arg x, toB, inB           /*get a number,  toBase,  and  inBase. */
  /*╔══════════════════════════════════════════════════════════════════════════════════╗
    ║ Input to this function:    x       (X   is required  and it must be an integer). ║
    ║                          toBase    the base to convert   X   to    (default=10). ║
    ║                          inBase    the base  X  is expressed in    (default=10). ║
    ║                                                                                  ║
    ║                                    toBase & inBase  have a limit of:   2 ──► 90  ║
    ╚══════════════════════════════════════════════════════════════════════════════════╝*/
      @abc= 'abcdefghijklmnopqrstuvwxyz'         /*the lowercase Latin alphabet letters.*/
      @abcU= @abc;         upper @abcU           /*go whole hog & extend with uppercase.*/
      @@@= 0123456789 || @abc || @abcU           /*prefix them with the decimal digits. */
      @@@= @@@'<>[]{}()?~!@#$%^&*_+-=|\/;:`'     /*add some special characters as well, */
                                                 /*──those chars should all be viewable.*/
      numeric digits 1000                        /*what the hey, support bigun' numbers.*/
      maxB= length(@@@)                          /*maximum base (radix) supported here. */
      if toB==''  then toB= 10                   /*if omitted,  then assume default (10)*/
      if inB==''  then inB= 10                   /* "    "        "     "      "      " */
      #=0                                        /* [↓] convert base inB  X  ──► base 10*/
             do j=1  for length(x)               /*process each "numeral" in the string.*/
             _= substr(x, j, 1)                  /*pick off a "digit" (numeral) from  X.*/
             v= pos(_, @@@)                      /*get the value of this "digit"/numeral*/
             if v==0 | v>inB  then call erd      /*is it an illegal "digit" (numeral) ? */
             #= # * inB    + v  - 1              /*construct new number, digit by digit.*/
             end   /*j*/
      y=                                         /* [↓] convert base 10  # ──► base toB.*/
             do  while  #>=toB                   /*deconstruct the  new   number (#).   */
             y= substr(@@@, # // toB  + 1,  1)y  /*  construct the output number,  ···  */
             #= # % toB                          /*  ···  and also whittle down  #.     */
             end   /*while*/

      return substr(@@@,  # + 1,  1)y            /*return a constructed "numeric" string*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
erd:  say 'the character '   v    " isn't a legal numeral for base "    inB'.';    exit 13
VdC:  return '.'reverse( base( arg(1), arg(2) )) /*convert the #, reverse the #, append.*/
