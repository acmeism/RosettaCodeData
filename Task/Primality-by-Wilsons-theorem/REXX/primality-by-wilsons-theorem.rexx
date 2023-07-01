/*REXX pgm tests for primality via Wilson's theorem: a # is prime if p divides (p-1)! +1*/
parse arg LO zz                                  /*obtain optional arguments from the CL*/
if LO=='' | LO==","  then LO= 120                /*Not specified?  Then use the default.*/
if zz ='' | zz =","  then zz=2 3 9 15 29 37 47 57 67 77 87 97 237 409 659 /*use default?*/
sw= linesize() - 1;  if sw<1  then sw= 79        /*obtain the terminal's screen width.  */
digs = digits()                                  /*the current number of decimal digits.*/
#= 0                                             /*number of  (LO)  primes found so far.*/
!.= 1                                            /*placeholder for factorial memoization*/
$=                                               /*     "      to hold a list of primes.*/
    do p=1  until #=LO;         oDigs= digs      /*remember the number of decimal digits*/
    ?= isPrimeW(p)                               /*test primality using Wilson's theorem*/
    if digs>Odigs  then numeric digits digs      /*use larger number for decimal digits?*/
    if \?  then iterate                          /*if not prime, then ignore this number*/
    #= # + 1;                   $= $ p           /*bump prime counter; add prime to list*/
    end   /*p*/

call show 'The first '    LO    " prime numbers are:"
w= max( length(LO), length(word(reverse(zz),1))) /*used to align the number being tested*/
@is.0= "            isn't";     @is.1= 'is'      /*2 literals used for display: is/ain't*/
say
    do z=1  for words(zz);      oDigs= digs      /*remember the number of decimal digits*/
    p= word(zz, z)                               /*get a number from user─supplied list.*/
    ?= isPrimeW(p)                               /*test primality using Wilson's theorem*/
    if digs>Odigs  then numeric digits digs      /*use larger number for decimal digits?*/
    say right(p, max(w,length(p) ) )       @is.?      "prime."
    end   /*z*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrimeW: procedure expose !. digs;  parse arg x '' -1 last;        != 1;       xm= x - 1
          if x<2                   then return 0 /*is the number too small to be prime? */
          if x==2 | x==5           then return 1 /*is the number a two or a five?       */
          if last//2==0 | last==5  then return 0 /*is the last decimal digit even or 5? */
          if !.xm\==1  then != !.xm              /*has the factorial been pre─computed? */
                       else do;  if xm>!.0  then do; base= !.0+1; _= !.0;  != !._; end
                                            else     base= 2        /* [↑] use shortcut.*/
                                      do j=!.0+1  to xm;  != ! * j  /*compute factorial.*/
                                      if pos(., !)\==0  then do;  parse var !  'E'  expon
                                                                  numeric digits expon +99
                                                                  digs = digits()
                                                             end    /* [↑] has exponent,*/
                                      end   /*j*/                   /*bump numeric digs.*/
                            if xm<999  then do; !.xm=!; !.0=xm; end /*assign factorial. */
                            end                                     /*only save small #s*/
          if (!+1)//x==0  then return 1                             /*X  is     a prime.*/
                               return 0                             /*"  isn't  "   "   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg header,oo;     say header        /*display header for the first N primes*/
      w= length( word($, LO) )                   /*used to align prime numbers in $ list*/
        do k=1  for LO; _= right( word($, k), w) /*build list for displaying the primes.*/
        if length(oo _)>sw  then do;  say substr(oo,2);  oo=;  end  /*a line overflowed?*/
        oo= oo _                                                    /*display a line.   */
        end   /*k*/                                                 /*does pretty print.*/
      if oo\=''  then say substr(oo, 2);  return /*display residual (if any overflowed).*/
