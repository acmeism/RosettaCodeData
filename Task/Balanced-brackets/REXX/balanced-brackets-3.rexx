/*REXX program checks for around 125,000 generated balanced brackets expressions  [ ]   */
bals=0
#=0;      do j=1  until  L>20                    /*generate lots of bracket permutations*/
          q=translate( strip( x2b( d2x(j) ), 'L', 0),  "][", 01)        /*convert ──► ][*/
          L=length(q)
          if countStr(']', q) \== countstr('[', q)  then iterate        /*not compliant?*/
          #=#+1                                                         /*bump legal Q's*/
          !=0;     do k=1  for L;      parse var q ? 2 q
                   if ?=='['  then     !=!+1
                              else do; !=!-1;  if !<0  then iterate j;  end
                   end   /*k*/

          if !==0  then bals=bals+1
          end  /*j*/                             /*done all 20─character possibilities? */

say #   " expressions were checked, "     bals    ' were balanced, ' ,
                                        #-bals    " were unbalanced."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
countStr: procedure;   parse arg n,h,s;    if s==''  then s=1;       w=length(n)
               do r=0  until _==0;   _=pos(n,h,s);   s=_+w;   end;      return r
