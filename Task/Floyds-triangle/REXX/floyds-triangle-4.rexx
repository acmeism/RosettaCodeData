/*REXX program constructs/shows Floyd's triangle for any number of rows in any base ≤90.*/
parse arg N radx .                               /*obtain optional arguments from the CL*/
if    N=='' |    N==","  then    N= 5            /*Not specified?  Then use the default.*/
if radx=='' | radx==","  then radx=10            /* "      "         "   "   "     "    */
mx=N * (N+1) % 2  -  N                           /*calculate maximum value of any value.*/
say 'displaying a '  N   " row Floyd's triangle in base"  radx':'  /*display the header.*/
say
#=1;  do     r=1  for N;   i=0;            _=    /*construct Floyd's triangle row by row*/
         do #=#  for r;    i=i+1                 /*start to construct a row of triangle.*/
         _=_ right(base(#, radx),  length( base(mx+i, radx) ) )    /*build triangle row.*/
         end   /*#*/
      say substr(_, 2)                           /*remove 1st leading blank in the line,*/
      end      /*r*/                             /* [↑]   introduced by first abutment. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
base: procedure; parse arg x 1 ox,toB,inB              /*obtain number, toBase, inBase. */
      @abc= 'abcdefghijklmnopqrstuvwxyz'               /*lowercase Latin alphabet.      */
      @abcU=@abc;        upper @abcU                   /*go whole hog and extend 'em.   */
      @@@= '0123456789'@abc || @abcU                   /*prefix 'em with numeric digits.*/
      @@@=@@@'<>[]{}()?~!@#$%^&*_=|\/;:¢¬≈'            /*add some special chars as well.*/
                             /* [↑]  handles up to base 90,  all chars must be viewable.*/
      numeric digits 3000                              /*what the hey, support gihugeics*/
      mxB=length(@@@)                                  /*max base (radix) supported here*/
      if toB=='' | toB=="," then toB=10                /*if skipped, assume default (10)*/
      if inB=='' | inB=="," then inB=10                /* "    "        "      "      " */
      if inB<2   | inb>mxB  then call erb 'inBase',inB /*invalid/illegal arg:   inBase. */
      if toB<2   | tob>mxB  then call erb 'toBase',toB /*    "      "     "     toBase. */
      if x==''              then call erm              /*    "      "     "     number. */
             sigX=left(x, 1)                           /*obtain a possible leading sign.*/
      if pos(sigX, '-+')\==0  then x=substr(x, 2)      /*X  number has a leading sign?  */
                              else sigX=               /*           ··· no leading sign.*/
      #=0
            do j=1  for length(x);  _=substr(x, j, 1)  /*convert X, base inB ──► base 10*/
            v=pos(_, @@@)                              /*get the value of this "digit". */
            if v==0 | v>inB  then call erd x,j,inB     /*is this an illegal "numeral" ? */
            #=# * inB + v - 1                          /*construct new num, dig by dig. */
            end   /*j*/
      y=
            do  while  # >= toB                        /*convert #, base 10 ──► base toB*/
            y=substr(@@@, (# // toB) + 1, 1)y          /*construct the number for output*/
            #=# % toB                                  /* ··· and whittle  #  down also.*/
            end   /*while*/

      y=sigX || substr(@@@, #+1, 1)y                   /*prepend the sign if it existed.*/
      return y                                         /*return the number in base  toB.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
erb:  call ser  'illegal'   arg(2)   "base: "   arg(1)   "must be in range:  2──► "    mxB
erd:  call ser  'illegal "digit" in'            x":"     _
erm:  call ser  'no argument specified.'
ser:  say; say  '***error***';             say arg(1);     say;      exit 13
