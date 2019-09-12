/*REXX program calculates the  Nth  Fibonacci number,   N   can be  zero  or  negative. */
numeric digits 210000                            /*be able to handle ginormous numbers. */
parse  arg  x y .                                /*allow a  single number  or  a range. */
if x=='' | x==","  then do;  x=-40;  y=+40;  end /*No input?  Then use range -40 ──► +40*/
if y=='' | y==","  then y=x                      /*if only one number, display   fib(X).*/
w= max(length(x),  length(y) )                   /*W:  used for making formatted output.*/
fw= 10                                           /*Minimum maximum width. Sounds ka─razy*/
      do j=x  to y;          q= fib(j)           /*process all of the Fibonacci requests*/
      L= length(q)                               /*obtain the length (decimal digs) of Q*/
      fw= max(fw, L)                             /*fib number length, or the max so far.*/
      say 'Fibonacci('right(j,w)") = "  right(q,fw)                   /*right justify Q.*/
      if L>10  then  say    'Fibonacci('right(j, w)") has a length of"     L
      end   /*j*/                                /* [↑]  list a Fib. sequence of  x──►y */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fib:  procedure; parse arg n;        an= abs(n)  /*use  │n│   (the absolute value of N).*/
      a= 0;    b= 1;   if an<2  then return an   /*handle two special cases: zero & one.*/
                                                 /* [↓]   this method is non─recursive. */
         do k=2  to an;   $= a+b;   a= b;   b= $ /*sum  the numbers  up to   │n│        */
         end   /*k*/                             /* [↑]  (only positive Fibs nums used).*/
                                                 /* [↓]  an//2   [same as]   (an//2==1).*/
      if n>0 | an//2   then  return  $           /*Positive or even?   Then return sum. */
                             return -$           /*Negative and odd? Return negative sum*/
