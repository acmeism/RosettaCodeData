/*REXX program to add a  (either metric or "binary" metric)  suffix to a decimal number.*/
@.=                                              /*default value for the stemmed array. */
parse arg @.1                                    /*obtain optional arguments from the CL*/
if @.1==''  then do;   @.1=   '   87,654,321                              '
                       @.2=   '  -998,877,665,544,332,211,000    3        '
                       @.3=   '  +112,233                        0        '
                       @.4=   '   16,777,216                     1        '

                       @.5=   '   456,789,100,000,000            2        '
                       @.5=   '   456,789,100,000,000                     '

                       @.6=   '   456,789,100,000,000            2    10  '
                       @.7=   '   456,789,100,000,000            5     2  '
                       @.8=   '   456,789,100,000.000e+00        0    10  '
                       @.9=   '   +16777216                      ,     2  '
                       @.10=  '   1.2e101                                 '
                       @.11=  '   134,112,411,648                1        '    /*via DIR*/
                 end                             /*@.11≡  amount of free space on my C: */

     do i=1  while @.i\==''; say copies("─", 60) /*display a separator betweenst values.*/
     parse var  @.i  x  f  r  .                  /*get optional arguments from the list.*/
     say '     input number='          x         /*show original number     to the term.*/
     say '    fraction digs='             f      /*  "  specified fracDigs   "  "    "  */
     say '  specified radix='                r   /*  "  specified radix      "  "    "  */
     say '       new number='  suffize(x, f, r)  /*maybe append an "alphabetic" suffix. */
     end   /*i*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
suffize: procedure; arg s 2 1 n,  f,  b          /*obtain:  sign, N, fractionDigs, base.*/
         if digits()<99  then numeric digits 500 /*use enough dec. digs for arithmetic. */
         @err = '***error*** (from SUFFIZE)  '   /*literal used when returning err msg. */
         if b==''  then b= 10;              o= b /*assume a base  (ten)  if omitted.    */
         n= space( translate(n,,','), 0);   m= n /*elide commas from the  1st  argument.*/
         f= space( translate(f,,','), 0)         /*elide commas from the  2nd  argument.*/
         if \datatype(n, 'N')  then return @err "1st argument isn't numeric."
         if f==''  then f= length(space(translate(n,,.), 0)) /*F omitted?  Use full len.*/
         if \datatype(f, 'W')  then return @err "2nd argument isn't an integer: "     f
         if f<0                then return @err "2nd argument can't be negative. "    f
         if \datatype(b, 'W')  then return @err "3rd argument isn't an integer. "     b
         if b\==10  &  b\==2   then return @err "3rd argument isn't a  10  or  2."    b
         if arg()>3            then return @err "too many arguments were specified."
         @=  ' KMGTPEZYXWVU'                     /*metric uppercase suffixes, with blank*/
         !.=;    !.2= 'i'                        /*set default suffix;  "binary" suffix.*/
         i= 3;   b= abs(b);  if b==2  then i= 10 /*a power of ten; or a power of  2**10 */
         if \datatype(n, 'N') | pos('E', n/1)\==0  then return m   /* ¬num or has an "E"*/
         sig=;    if s=='-' | s=="+"  then sig=s /*preserve the number's sign if present*/
         n= abs(n)                               /*possibly round number, & remove sign.*/

           do while n>=1e100 & b==10;  x=n/1e100 /*is N ≥ googol and base=10?  A googol?*/
           if pos(., x)\==0 & o<0  then leave    /*does # have a dec. point  or is B<0? */
           return sig  ||  x'googol'             /*maybe prepend the sign,  add GOOGOL. */
           end   /*while*/

           do j=length(@)-1  to 1  by -1  while n>0  /*see if #  is a multiple of 1024. */
           $= b ** (i*j)                             /*compute base raised to a power.  */
           if n<$  then iterate                      /*N not big enough?   Keep trying. */
           n= format(n/$, , min( digits(), f) ) / 1  /*reformat number with a fraction. */
           if pos(., n)\==0 & o<0  then return m     /*has a decimal point  or  is B<0? */
           leave                                     /*leave this DO loop at this point.*/
           end   /*j*/

         if n=0  then j=0                            /*N = 0?    Don't use any suffix.  */
         return sig||strip(n||substr(@, j+1,1))!.b   /*add sign, suffixes, strip blanks.*/
