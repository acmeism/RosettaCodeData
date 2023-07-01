/*REXX program solves the knapsack/unbounded problem: highest value, weight, and volume.*/

                           /*   value                   weight                   volume */
maxPanacea= 0              /*  ═══════                  ══════                   ══════ */
maxIchor  = 0;      panacea.$ = 3000  ;      panacea.w =  0.3 ;       panacea.v = 0.025
maxGold   = 0;        ichor.$ = 1800  ;        ichor.w =  0.2 ;         ichor.v = 0.015
max$      = 0;         gold.$ = 2500  ;         gold.w =  2   ;          gold.v = 0.002
now.      = 0;         sack.$ =    0  ;         sack.w = 25   ;          sack.v = 0.25

maxPanacea= min(sack.w / panacea.w,     sack.v / panacea.v)
maxIchor  = min(sack.w /   ichor.w,     sack.v /   ichor.v)
maxGold   = min(sack.w /    gold.w,     sack.v /    gold.v)

  do     p=0  to maxPanacea
    do   i=0  to maxIchor
      do g=0  to maxGold
      now.$= g * gold.$     +     i * ichor.$     +     p * panacea.$
      now.w= g * gold.w     +     i * ichor.w     +     p * panacea.w
      now.v= g * gold.v     +     i * ichor.v     +     p * panacea.v
      if now.w > sack.w  |  now.v  > sack.v  then iterate
      if now.$ > max$  then do;   maxP= p;          maxI= i;            maxG= g
                                  max$= now.$;      maxW= now.w;        maxV= now.v
                            end
      end  /*g  (gold)   */
    end    /*i  (ichor)  */
  end      /*p  (panacea)*/

Ctot = maxP + maxI + maxG;                 L = length(Ctot) + 1
say '    panacea in sack:'     right(maxP, L)
say '     ichors in sack:'     right(maxI, L)
say ' gold items in sack:'     right(maxG, L)
say '════════════════════'     copies("═", L)
say 'carrying a total of:'     right(cTot, L)
                           say left('', 40)     "total  value: "        max$ / 1
                           say left('', 40)     "total weight: "        maxW / 1
                           say left('', 40)     "total volume: "        maxV / 1
                                                 /*stick a fork in it,  we're all done. */
