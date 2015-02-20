/*REXX program calculates the Nth Fibonacci number, N can be zero or neg*/
numeric digits 210000                  /*be able to handle some big 'uns*/
parse  arg  x y .                      /*allow a single number or range.*/
if x==''  then do;  x=-40;  y=+40; end /*No input? Use range -40 ──► +40*/
if y==''  then y=x                     /*if only one number, show fib(n)*/
w=max(length(x), length(y))            /*used for making output pretty. */
fw=10                                  /*minmum maximum width.  Ka-razy.*/
      do j=x  to y;         q=fib(j)   /*process each Fibonacci request.*/
      L=length(q)                      /*obtain the length (width) of Q.*/
      fw=max(fw, L)                    /*fib# length or the max so far. */
      say 'Fibonacci('right(j,w)") = " right(q,fw)   /*right justify  Q.*/
      if L>10  then  say  'Fibonacci('right(j,w)") has a length of"   L
      end   /*j*/                      /* [↑]  list a Fib seq. of x──►y */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FIB subroutine──────────────────────*/
fib:  procedure;  parse arg n;   a=0;    b=1;   na=abs(n)    /*use |n|  */
if na<2  then return na                /*handle 3 special cases (-1,0,1)*/
                                       /* [↓]   method is non-recursive.*/
   do k=2  to na;  s=a+b;  a=b;  b=s   /*sum  the numbers  up to   │n│  */
   end   /*k*/                         /* [↑]  (only positive Fibs used)*/
                                       /* [↓]  na//2  [same as] na/2==1 */
if n>0 | na//2   then  return  s       /*if positive or odd negative ···*/
                       return -s       /*return a negative Fib number.  */
