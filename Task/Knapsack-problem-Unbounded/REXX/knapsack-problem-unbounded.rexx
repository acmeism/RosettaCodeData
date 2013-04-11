/*REXX program solves a  knapsack/unbounded  problem.                   */
maxPanacea=0
maxIchor  =0
maxGold   =0
max$      =0
current.  =0

       /*  value              weight             volume  */
       /* ═══════             ═══════            ══════  */
panacea.$= 3000 ;   panacea.w=  0.3 ;  panacea.v= 0.025
  ichor.$= 1800 ;     ichor.w=  0.2 ;    ichor.v= 0.015
   gold.$= 2500 ;      gold.w=  2   ;     gold.v= 0.002
   sack.$=    0 ;      sack.w= 25   ;     sack.v= 0.25

maxPanacea = min(sack.w/panacea.w,  sack.v/panacea.v)
maxIchor   = min(sack.w/  ichor.w,  sack.v/  ichor.v)
maxGold    = min(sack.w/   gold.w,  sack.v/   gold.v)

  do     p=0  to maxpanacea
    do   i=0  to maxichor
      do g=0  to maxgold
      current.$=g*gold.$ + i*ichor.$ + p*panacea.$
      current.w=g*gold.w + i*ichor.w + p*panacea.w
      current.v=g*gold.v + i*ichor.v + p*panacea.v
      if current.w>sack.w | current.v>sack.v then iterate
      if current.$>max$  then do
                              max$   = current.$
                              totalW = current.w
                              totalV = current.v
                              maxP=p;     maxI=i;     maxG=g
                              end
      end   /*g (gold)   */
    end     /*i (ichor)  */
  end       /*p (panacea)*/

cTot=maxP+maxI+maxG
L=length(cTot)+1
say '    panacea in sack:'  right(maxP,L)
say '     ichors in sack:'  right(maxI,L)
say ' gold items in sack:'  right(maxG,L)
say '════════════════════'  copies('═',L)
say 'carrying a total of:'  right(cTot,L)
say left('',40)  'total  value: '  max$/1
say left('',40)  'total weight: '  totalW/1
say left('',40)  'total volume: '  totalV/1
                                       /*stick a fork in it, we're done.*/
