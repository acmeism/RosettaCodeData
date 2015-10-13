/*REXX program solves the   Hofstadter-Conway  $10,000   prize  (puzzle).     */
hC.=;     !.=0;     @.=0;      w=0;      wi=0;      few=70;      L=

     do i=1  for few;    L=L hc(i)     /*build the 1st 70 numbers in sequence.*/
     end   /*i*/
                                       /*wearing a belt & suspenders, show ···*/
say 'The first'    few    "numbers in the Hofstadter─Conway sequence:"
say strip(L)                           /*display the list, trees have to die. */
say                                    /*show a blank line for the eyeballs.  */
     do k=0  to 20                     /*build an array of the powers of two. */
     p.k=2**k                          /*Bang-bang!.   Er, ··· I mean pow-pow.*/
     maxp=p.k                          /*   ··· and remember who's da big 'un.*/
     end   /*k*/
r=1                                    /*R:  is the range of the power of two.*/
     do n=1  for maxp                  /*heck,  let's get cracking then ···   */
     if n>p.r  then r=r+1              /*for golf coders:    r = r + (n>p.r)  */
     _=hc(n)/n;   if _>=.55 then w=n   /*get next seq number; if ≥.55, a win? */
     if _<=@.r  then iterate           /*less than prev?   Then keep truckin'.*/
     @.r=_;   !.r=n                    /*@.r and  !.r  are like ginkgo biloba.*/
     end   /*n*/

pref='Maximum of    a(n) ÷ n     between '   /*prefix for the text of message.*/

    do j=1  for 20;   range='2**'right(j-1,2)             "───► 2**"right(j,2)
    say pref range   '(inclusive)  is '    left(@.j,8)    '  at  n='right(!.j,7)
    end   /*j*/
say
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
hC:  procedure expose hC.;       parse arg n;         if n<3  then return 1
     if hC.n==''  then  hC.n = hC(hC(n-1)) + hC(n-hC(n-1))
     return hC.n                       /*return with the goodie stuff (high). */
