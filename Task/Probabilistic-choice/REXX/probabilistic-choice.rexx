/*REXX pg shows results of probabilistic choices (gen rand#s per prob.) */
parse arg trials digits seed .         /*obtain some optional arguments.*/
if trials=='' | trials==','  then trials=1000000
if digits=='' | digits==','  then digits=15;         digits=max(10,digits)
if  seed\==''                then call random ,,seed /*for repeatability*/
names='aleph beth gimel daleth he waw zayin heth ──totals───►'
cells=words(names) - 1;      high=100000;  s=0;                 !.=0
_=4
       do n=1  for 7; _=_+1; prob.n=1/_;   Hprob.n=prob.n*high; s=s+prob.n
       end   /*n*/                     /* [↑]  determine probabilities. */

prob.8=1759/27720;  Hprob.8=prob.8*high;  s=s+prob.8; prob.9=s; !.9=trials

  do j=1  for trials; r=random(1,high) /*generate X number of random #s.*/
     do k=1  for cells                 /*now, for each cell, compute %s.*/
     if r<=Hprob.k  then !.k=!.k+1     /*for each range, bump da counter*/
     end   /*k*/
  end      /*j*/

w=digits+6;         d=max(length(trials), length('count')) + 4
say center('name',15,'─') center('count',d,'─') center('target %',w,'─'),
    center('actual %',w,'─')           /*display a formatted header line*/

         do i=1  for cells+1           /*show for each cell and totals. */
         say  '  '  left(word(names,i)            ,    12),
                    right(!.i                     ,   d-2)  ' ',
                    left(format(prob.i    *100, d),   w-2),
                    left(format(!.i/trials*100, d),   w-2)
         if i==8  then say center('',15,'─')    center('',d,'─'),
                           center('', w,'─')    center('',w,'─')
         end   /*i*/
                                       /*stick a fork in it, we're done.*/
