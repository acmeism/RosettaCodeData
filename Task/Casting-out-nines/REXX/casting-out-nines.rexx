/*REXX program to demonstrate casting-out-nines (with Kaprekar numbers).*/
parse arg start stop base .            /*get the user args (if any).    */
if base==''   then base=10             /*use base ten if not specified. */
if start==''  then do; start=1; stop=1000; end       /*use the defaults?*/
if stop==''   then stop=start          /*not specified?  Use the default*/
numbers=castOut(start,stop,base)       /*generate a list of numbers.    */
@cast_out='cast-out-'||(base-1) "test" /*construct a text shortcut.     */
say 'For'  start  "through" stop', the following passed the'  @cast_out":"
say numbers;  say                      /*display the list of numbers.   */
q=stop-start+1                         /*Q  is the range of  #s in list.*/
p=words(numbers)                       /*P  is the number of #s in list.*/
pc=format(p/q*100,,2)/1 || '%'         /*calculate the percentage (%).  */
say 'For' q "numbers,"  p 'passed the' @cast_out "("pc') for base' base"."
if base\==10  then exit                /*if radix ¬ ten, then stop pgm. */
Kaps=kaprekar(start,stop)              /*generate a list of Kaprekar #s.*/
say;  say 'The Kaprekar numbers in the same range are:' Kaps
say
      do i=1  for words(Kaps);  x=word(Kaps,i)    /*verify 'em in list. */
      if wordpos(x,numbers)\==0  then iterate     /*OK so far ...       */
      say 'Kaprekar number'  x  "isn't in the numbers list."     /*oops!*/
      exit                                        /*go spank the coder. */
      end

say 'All Kaprekar numbers are in the' @cast_out "numbers list."     /*ok*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────CASTOUT subroutine──────────────────*/
castOut:  procedure;  parse arg low,high,radix;  $=
 high=word(high low,1)                 /*use default of  LOW  for  HIGH.*/
radix=word(radix 10,1)                 /*use default ot   10  for RADIX.*/
niner=radix-1                          /*a fast way to use  RADIX - 1.  */
                  do j=low  to high    /*traipse through the arg range. */
                  if j//niner==j*j//niner  then $=$ j   /*pass the test?*/
                  end   /*j*/
return strip($)                        /*strip leading blank from result*/
/*──────────────────────────────────Kaprekar subroutine─────────────────*/
kaprekar:  procedure;  parse arg L,H;    #=0;   $=;    if L<=1  then $=1
numeric digits max(10,2*length(H**2))  /*insure enough digits for H².   */
  do j=max(2,L)  to H;         s=j*j   /*slow way to find Kaprekar #'s. */
      do k=1  for length(s)%2
      if j==left(s,k)+substr(s,k+1)  then $=$ j    /*found a Kaprekar #.*/
      end   /*k*/
  end       /*j*/
return strip($)                        /*return all the Kaprekar numbers*/
