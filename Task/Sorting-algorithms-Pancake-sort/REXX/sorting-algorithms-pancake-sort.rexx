/*REXX program  sorts and displays  an array  using the  pancake sort  algorithm.       */
call gen                                         /*generate elements in the   @.  array.*/
call show          'before sort'                 /*display the   BEFORE  array elements.*/
say copies('▒', 60)                              /*display a separator line for eyeballs*/
call pancakeSort         #                       /*invoke the   pancake  sort.   Yummy. */
call show          ' after sort'                 /*display the    AFTER array elements. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
flip: parse arg y;  do i=1  for (y+1)%2; yyy=y-i+1; _=@.i; @.i=@.yyy; @.yyy=_; end; return
show: do k=1  for #;  say @element right(k,length(#)) arg(1)':' right(@.k,9);  end; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen:  fibs= '-55 -21 -1 -8 -8 -21 -55 0 0'       /*some non─positive Fibonacci numbers, */
      @element= right('element', 21)             /*     most Fibs of which are repeated.*/

      /* ┌◄─┬──◄─ some paired bread primes which are of the form:  (P-3)÷2  and  2∙P+3  */
      /* │  │     where P is a prime. Bread primes are related to sandwich & meat primes*/
      /* ↓  ↓ ──── ──── ───── ────── ────── ────── ────── ─────── ─────── ─────── ──────*/
      bp=2 17 5 29 7 37 13 61 43 181 47 197 67 277 97 397 113 461 137 557 167 677 173 701,
                                                      797 1117 307 1237 1597 463 1861 467
      $=bp fibs;         #=words($)              /*combine the two lists; get # of items*/
             do j=1  for #;  @.j=word($,j);  end /*◄─── obtain a number from the $ list.*/
      return                                     /* [↑]  populate the  @.  array with #s*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
pancakeSort: procedure expose @.;   parse arg N
                       do N=N  by -1  for N-1
                       !=@.1;  ?=1;                do j=2  to N;   if @.j<=!  then iterate
                                                   !=@.j;          ?=j
                                                   end   /*j*/
                       call flip ?;   call flip N
                       end   /*N*/
             return
