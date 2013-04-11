/*REXX program calculates the Nth Fibonacci number, N can be zero or neg*/
numeric digits 210000                  /*prepare for some big 'uns.     */
parse arg x y .                        /*allow a single number or range.*/
if x=='' then do; x=-40; y=abs(x); end /*No input? Use range -40 ──► +40*/
if y=='' then y=x                      /*if only one number, show fib(n)*/
w=max(length(x),length(y))             /*used for making output pretty. */
fw=10                                  /*minmum maximum width.   Ka-razy*/
      do j=x to y;   q=fib(j)          /*process each Fibonacci request.*/
      fw=max(fw,length(q))             /*fib# length or the max so far. */
      say 'Fibonacci('right(j,w)") = " right(q,fw)   /*right justify  Q.*/
      if length(q)>10 then say 'Fibonacci('right(j,w)") has a length of" l
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────FIB subroutine (non-recursive)───*/
fib:  procedure;    parse arg n;     na=abs(n);     a=0;     b=1
if na<2 then return na                 /*handle couple of special cases.*/

      do k=2 to na;    s=a+b           /*sum  the numbers  up to  │n│   */
      parse value  b s  with  a b      /*faster version of:   a=b;  s=b */
      end   /*k*/

if n>0 | na//2==1  then  return  s     /*if positive or odd negative ...*/
                         return -s     /*  return a negative Fib number.*/
