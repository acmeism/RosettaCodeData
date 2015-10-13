/*REXX program shows results of probabilistic choices, gen random #s per prob.*/
parse arg trials digits seed .         /*obtain the optional arguments from CL*/
if trials=='' | trials==','  then trials=1000000
if digits=='' | digits==','  then digits=15;         digits=max(10,digits)
if  seed\==''                then call random ,,seed      /*for repeatability.*/
names='aleph beth gimel daleth he waw zayin heth ──totals───►'
cells=words(names) - 1;      high=100000;  s=0;                 !.=0
_=4
       do n=1  for 7; _=_+1; prob.n=1/_;   Hprob.n=prob.n*high; s=s+prob.n
       end   /*n*/                     /* [↑]  determine the probabilities.   */

prob.8=1759/27720;  Hprob.8=prob.8*high;  s=s+prob.8; prob.9=s; !.9=trials

  do j=1  for trials; r=random(1,high) /*generate  X number of random numbers.*/
     do k=1  for cells                 /*for each cell, compute percentages.  */
     if r<=Hprob.k  then !.k=!.k+1     /*for each range, bump the counter.    */
     end   /*k*/
  end      /*j*/

w=digits+6;         d=max(length(trials), length('count')) + 4
say centr('name',15)   centr('count',d)   centr('target %')   centr('actual %')
                                       /* [↑]  display a formatted header line*/
         do i=1  for cells+1           /*show for each of the cells and totals*/
         say  '  '  left(word(names,i)            ,    12),
                    right(!.i                     ,   d-2)  ' ',
                    left(format(prob.i    *100, d),   w-2),
                    left(format(!.i/trials*100, d),   w-2)
         if i==8  then say centr(,15)   centr(,d)   centr()   centr()
         end   /*i*/
exit                                   /*stick a fork in it,  we are all done.*/
/*────────────────────────────────────────────────────────────────────────────*/
centr:  return center(arg(1), word(arg(2) w,1), '─')
