/*REXX program selects all even numbers from an array  ──► a new array. */
numeric digits 210000                  /*handle past  1m  for Fibonacci.*/
old.=                                  /*the OLD array, all null so far.*/
new.=                                  /*the NEW array, all null so far.*/
  do j=-40 to 40;  old.j=fib(j);  end  /*put 81 Fibonacci numbs ==> OLD */
news=0                                 /*numb. of elements in NEW so far*/

/*══════════════════════════════════════════════════════════════════════*/
      do k=-40  while old.k\==''       /*process the OLD array elements.*/
      if old.k//2 \== 0 then iterate   /*if element isn't even, skip it.*/
      news=news+1                      /*bump the number of NEW elements*/
      new.news=old.k                   /*assign it to the NEW array.    */
      end
/*══════════════════════════════════════════════════════════════════════*/

      do j=1  for news                 /*display all the NEW  numbers.  */
      say 'new.'j "=" new.j
      end
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────FIB subroutine (non-recursive)───*/
fib: procedure; parse arg n; na=abs(n); if na<2 then return na /*special*/
a=0;  b=1
                do j=2 to na; s=a+b; a=b; b=s; end

if n>0 | na//2==1  then return  s      /*if positive or odd negative... */
                   else return -s      /*return a negative Fib number.  */
