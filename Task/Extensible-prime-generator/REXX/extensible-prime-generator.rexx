/*REXX program calculates and displays primes using an extendible prime number generator*/
parse arg f .;    if f==''  then f= 20           /*allow specifying number for  1 ──► F.*/
_i= ' (inclusive) ';  _b= 'between ';  _tnp= 'the number of primes' _b;  _tn= 'the primes'
call primes f;      do j=1  for f;      $= $ @.j;    end  /*j*/
                                        say 'the first '    f    " primes are: "        $
                                        say
call primes -150;   do j=100  to 150;   if !.j==1  then $= $ j;  end  /*j*/
                                        say _tn  _b  '100  to  150'  _i  "are: "        $
                                        say
call primes -8000;  do j=7700  to 8000; if !.j==1  then $= $ j;  end  /*j*/
                                        say _tnp  '7,700  and  8,000'  _i  "is: " words($)
                                        say
call primes 10000
                                        say 'the 10,000th prime is: '    @.10000
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
primes: procedure expose !. @. $ #;      parse arg H,,$;           Hneg= H<0;    H= abs(H)
        if symbol('#')=="LIT"  then call .primI  /*1st time here?  Then initialize stuff*/
        if Hneg  then  if  H<=@.#  then return   /*do we have a high enough  P  already?*/
                                   else nop      /*this is used to match the above THEN.*/
                 else  if  H<=#    then return   /*are there enough primes currently ?  */
                                                 /* [↓]  gen more primes within range.  */
          do j=@.#+2   by 2; parse var j '' -1 _ /*find primes until have   H   Primes. */
          if     _==5  then iterate              /*is the right─most digit a 5  (five)? */
          if j// 3==0  then iterate              /*is  J  divisible by  three?  (& etc.)*/
          if j// 7==0  then iterate;  if j//11==0  then iterate; if j//13==0  then iterate
          if j//17==0  then iterate;  if j//19==0  then iterate; if j//23==0  then iterate
          if j//29==0  then iterate;  if j//31==0  then iterate; if j//37==0  then iterate
          if j//41==0  then iterate;  if j//43==0  then iterate; if j//47==0  then iterate
          if j//53==0  then iterate;  if j//59==0  then iterate; if j//61==0  then iterate
          if j//67==0  then iterate;  if j//71==0  then iterate; if j//73==0  then iterate
          if j//79==0  then iterate;  if j//83==0  then iterate; if j//89==0  then iterate
          if j//97==0  then iterate;  if j//101==0 then iterate; if j//103==0 then iterate
          x= j;          r= 0;  q= 1;   do while q<=x;  q= q*4;  end  /*R:  the sqrt(J).*/
                  do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q; end; end
                    do k=@.lowP   while @.k<=r   /*÷ by the known odd primes (hardcoded)*/
                    if j//@.k==0  then iterate j /*J ÷ by a prime?  Then not prime.  ___*/
                    end   /*k*/                  /* [↑]  divide by odd primes up to √ J */
          #= # + 1                               /*bump the number of primes found.     */
          @.#= j;                       !.j= 1   /*assign to sparse array;  prime²;  P#.*/
          if Hneg  then if H<=@.#  then leave    /*is this a high enough prime?         */
                                   else nop      /*used to match the above  THEN.       */
                   else if H<=#    then leave    /*have enough primes been generated?   */
          end   /*j*/                            /* [↑]  keep generating until enough.  */
        return                                   /*return to invoker with more primes.  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
.primI: !.=0;   @.=0;                            /*!.x= a prime or not;  @.n= Nth prime.*/
        L= 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103
                do #=1  for words(L);   p= word(L, #);   @.#= p;   !.p=1;    end   /*#*/
        #= # - 1;       @.lowP= #;      return   /*#:   # primes;  @.lowP:   start of ÷ */
