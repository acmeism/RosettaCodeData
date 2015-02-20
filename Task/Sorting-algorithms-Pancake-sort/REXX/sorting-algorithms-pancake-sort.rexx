/*REXX program sorts & shows an array using the pancake sort  algorithm.*/
call gen@                              /*generate elements in the array.*/
call show@  'before sort'              /*show the BEFORE array elements.*/
call pancakeSort    #                  /*invoke the pancake sort. Yummy.*/
call show@  ' after sort'              /*show the  AFTER array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FLIP subroutine─────────────────────*/
flip: procedure expose @.;             parse arg y
        do i=1  for (y+1)%2
        ymp=y-i+1;      _=@.i;      @.i=@.ymp;       @.ymp=_
        end   /*i*/
return
/*──────────────────────────────────GEN@ subroutine──────────────────────────────────────────────────────────────────*/
gen@:                          /*a few sorted bread primes which are primes of the form:    (p-3)÷2   and   2∙p+3    */
                               /*where  p  is a prime.      Bread primes are related to  sandwich and meat  primes.  */
bp=2 17 5 29 7 37 13 61 43 181 47 197 67 277 97 397 113 461 137 557 167 677 173 701 797 1117 307 1237 1597 463 1861 467
fb='-55 -21 -1 -8 -8 -21 -55 0 0'      /*some non-positive Fibonacci #s,*/
$=bp fb                                /*    most of which are repeated.*/
#=words($)                             /*get number of items in $ list. */
                                       /* [↓]  populate @ array with #s.*/
      do j=1 for #; @.j=word($,j); end /*obtain a number of the  $ list.*/
return
/*──────────────────────────────────PANCAKESORT subroutine──────────────*/
pancakeSort: procedure expose @.;   parse arg N

        do N=N  by -1  for N-1
        !=@.1;  ?=1;                do j=2  to N;  if @.j<=!  then iterate
                                    !=@.j;     ?=j
                                    end   /*j*/
        call flip ?;  call flip N
        end   /*N*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: w=length(#);   do k=1  for #
                      say '     element' right(k,w) arg(1)':' right(@.k,9)
                      end  /*k*/
say copies('█',40)                     /*show an eyeball separator line.*/
return
