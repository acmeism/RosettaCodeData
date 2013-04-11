/*REXX program solves the   Hofstadter-Conway  $10,000   prize.         */
hC.=;     i.=0;     m.=0;     n.=0;     w=0;     wi=0;     few=70;     L=

     do i=1  for few;    L=L hc(i)     /*build first 70 numbers in seq. */
     end   /*i*/
                                       /*I wear a belt and suspenders.  */
say 'The first'  few  "numbers in the Hofstadter-Conway sequence:"
say strip(L)                           /*show&tell, no trees have to die*/
say                                    /*show a blank line for the eyes.*/
     do k=0  to 20                     /*build an array,  powers of two.*/
     p.k=2**k                          /*Bang-bang!.  Er, I mean pow-pow*/
     maxp=p.k                          /*and remember who's da big 'un. */
     end   /*k*/
r=1                                    /*R: the range of the power of 2.*/
     do n=1  for maxp                  /*heck,  let's get cracking then.*/
     if n>p.r  then r=r+1              /*for golf players:  r=r+(n>p.r) */
     _=hc(n)/n;   if _>=.55 then w=n   /*get next seq #; if ≥.55, a win?*/
     if _<=m.r  then iterate           /*less than?  Then keep truckin'.*/
     m.r=_;   i.r=n                    /*m.r & i.r  is for ginkgo biloba*/
     end   /*n*/

pref='Maximum of    a(n) ÷ n     between '     /*prefix text of message.*/

    do j=1 for 20;   range='2**'right(j-1,2)  "───► 2**"right(j,2)
    say pref range '(inclusive)  is '  left(m.j,8)  '  at  n='right(i.j,7)
    end    /*j*/
say
say 'The winning number is: ' w        /*and the money shot is ...      */
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────hC [Hofstadter-Conway] subroutine*/
hC:  procedure expose hC.;     parse arg n;     if n<3 then return 1
if hC.n==''  then  hC.n = hC(hC(n-1)) + hC(n-hC(n-1))
return hC.n                            /*return with the goodie stuff.  */
