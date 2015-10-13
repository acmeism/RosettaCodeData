/*REXX program checks for numerous generated balanced (square) brackets  [ ]  */
bals=0
#=0;      do j=1  until length(q)>20   /*generate lots of bracket permutations*/
          q=translate(strip(x2b(d2x(j)),'L',0),"][",01)       /*convert ──► []*/
          if countStr(']',q)\==countstr('[',q)  then iterate  /*is compliant? */
          call checkBal q
          end  /*j*/                   /*have all 20─character possibilities? */
say
say #    " expressions were checked, "          bals '       were balanced, ' ,
                                              #-bals "       were unbalanced."
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
checkBal:  procedure expose # bals;       parse arg y;   #=#+1   /*bump count.*/
!=0
                   do j=1  for length(y)
                   if substr(y,j,1)=='['  then     !=!+1
                                          else do; !=!-1; if !<0 then leave; end
                   end   /*j*/
bals=bals + (!==0)
return       !==0
/*────────────────────────────────────────────────────────────────────────────*/
countStr: procedure;   parse arg n,h,s;    if s==''  then s=1;       w=length(n)
               do r=0  until _==0;   _=pos(n,h,s);   s=_+w;   end;      return r
