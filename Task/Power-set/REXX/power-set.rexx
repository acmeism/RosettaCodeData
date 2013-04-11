/*REXX program to display a power set, items may be anything (no blanks)*/
parse arg S                               /*let user specify the set.   */
if S=''  then S='one two three four'      /*None specified?  Use default*/
N=words(S)                                /*number of items in the list.*/
ps='{}'                                   /*start with a null power set.*/
              do chunk=1  for N           /*traipse through the items.  */
              ps=ps combN(N,chunk)        /*N items, a CHUNK at a time. */
              end    /*chunk*/
w=words(ps)
              do k=1  for w               /*show combinations, one/line.*/
              say right(k,length(w)) word(ps,k)
              end    /*k*/
exit                                      /*stick a fork in it, we done.*/
/*─────────────────────────────────────$COMBN subroutine────────────────*/
combN: procedure expose $ S;     parse arg x,y;    $=
!.=0;  base=x+1;  bbase=base-y;  ym=y-1;        do p=1 for y;  !.p=p;  end
                do j=1; L=
                           do d=1  for y;  _=!.d;  L=L','word(S,_);  end
                $=$ '{'strip(L,'L',",")'}'
                !.y=!.y+1;   if !.y==base  then if .combU(ym)  then leave
                end   /*j*/
return strip($)                           /*return with partial powerset*/

.combU: procedure expose !. y bbase;   parse arg d;  if d==0 then return 1
p=!.d;    do u=d  to y;    !.u=p+1
          if !.u==bbase+u  then return .combU(u-1)
          p=!.u
          end   /*u*/
return 0
