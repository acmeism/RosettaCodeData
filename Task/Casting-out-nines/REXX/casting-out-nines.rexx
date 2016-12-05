/*REXX program demonstrates the  casting─out─nines  algorithm  (with Kaprekar numbers). */
parse arg LO HI base .                           /*obtain optional arguments from the CL*/
if LO=='' | LO==","  then do; LO=1; HI=1000; end /*Not specified?   Then use the default*/
if HI=='' | HI==","  then HI=LO                  /* "      "          "   "   "     "   */
if base=='' | base==","  then base=10            /* "      "          "   "   "     "   */
numeric digits max(9, 2*length(HI**2) )          /*insure enough decimal digits for HI².*/
numbers=castOut(LO, HI, base)                    /*generate a list of (cast out) numbers*/
@cast_out= 'cast-out-'  || (base-1)     "test"   /*construct a shortcut text for output.*/
say 'For'     LO     "through"     HI', the following passed the'       @cast_out":"
say numbers;         say                         /*display the list of cast out numbers.*/
q=HI-LO+1                                        /*Q:   is the range of numbers in list.*/
p=words(numbers)                                 /*P"    "  " number  "    "     "   "  */
pc=format(p/q * 100, , 2) / 1  ||  '%'           /*calculate the percentage (%) cast out*/
say 'For'   q   "numbers,"   p   'passed the'    @cast_out    "("pc') for base'    base"."
if base\==10  then exit                          /*if radix isn't ten, then exit program*/
Kaps=Kaprekar(LO, HI)                            /*generate a list of Kaprekar numbers. */
say;  say   'The Kaprekar numbers in the same range are:'   Kaps
say
      do i=1  for words(Kaps);    x=word(Kaps, i)                  /*verify 'em in list.*/
      if wordpos(x, numbers)\==0  then iterate                     /*it's OK so far ··· */
      say 'Kaprekar number'   x   "isn't in the numbers list."     /*oops─ay!           */
      exit 13                                                      /*go spank the coder.*/
      end   /*i*/

say 'All Kaprekar numbers are in the'     @cast_out     "numbers list."             /*OK*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
castOut:  procedure;  parse arg low,high,radix;       rm=word(radix 10, 1) - 1;         $=
                          do j=low  to  word(high low, 1)    /*test a range of numbers. */
                          if j//rm == j*j//rm  then $=$ j    /*did number pass the test?*/
                          end   /*j*/                        /* [↑]  Then add # to list.*/
          return strip($)                        /*strip and leading blanks from result.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
Kaprekar: procedure;  parse arg L,H;   $=;   if L<=1  then $=1   /*add unity if in range*/
            do j=max(2, L)  to H;        s=j*j   /*a slow way to find Kaprekar numbers. */
                do m=1  for length(s) % 2
                if j==left(s, m) + substr(s, m+1)  then do;  $=$ j;  leave;   end
                end   /*m*/                      /*     [↑]  found a Kaprekar number.   */
            end       /*j*/
          return strip($)                        /*return Kaprekar numbers to invoker.  */
