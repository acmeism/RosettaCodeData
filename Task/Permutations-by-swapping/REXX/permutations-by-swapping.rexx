/*REXX pgm generates all permutations of N different objects by swapping*/
parse arg things bunch inbetween names          /*get optional C.L. args*/
if things=='' | things==','  then things=4      /*use the default?      */
if bunch =='' | bunch ==','  then bunch =things /* "   "     "          */
  /* ┌────────────────────────────────────────────────────────────────┐
     │         things  (optional)   defaults to 4.                    │
     │          bunch  (optional)   defaults to THINGS.               │
     │      inbetween  (optional)   defaults to a  [null].            │
     │          names  (optional)   defaults to digits (and letters). │
     └────────────────────────────────────────────────────────────────┘ */
upper inbetween;  if inbetween=='NONE' | inbetween="NULL"  then inbetween=
call permSets things, bunch, inbetween, names
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────! {factorial} subroutine────────────*/
!: procedure; parse arg x; !=1;     do j=2  to x; !=!*j; end;     return !
/*──────────────────────────────────GETONE subroutine───────────────────*/
getOne:  if length(z)==y  then return  substr(z,arg(1),1)
                          else return  sep||word(translate(z,,','),arg(1) )
/*──────────────────────────────────P subroutine (Pick one)─────────────*/
p:  return word(arg(1),1)
/*──────────────────────────────────PERMSETS subroutine─────────────────*/
permSets: procedure; parse arg x,y,between,uSyms /*X things Y at a time.*/
sep=;           !.=0                   /*X  can't be > length(@0abcs).  */
@abc = 'abcdefghijklmnopqrstuvwxyz';   parse upper var @abc @abcU
@abcS= @abcU || @abc;                  @0abcS=123456789 || @abcS
z=
     do i=1  for x                     /*build a list of (perm) symbols.*/
     _=p(word(uSyms,i)  p(substr(@0abcS,i,1) k))  /*get or gen a symbol.*/
     if length(_)\==1  then sep=','    /*if not 1st char, then use sep. */
     z=z || sep || _                   /*append it to the symbol list.  */
     end   /*i*/

if sep\==''  then z=strip(z,'L', ",")
!.z=1;  #=1;  times=!(x)%!(x-y);  q=z;  s=1;  w=max(length(z),length('permute'))
say  center('permutations for '   x   ' with '    y    "at a time",60,'═')
say
say   'permutation'    center("permute",w,'─')    'sign'
say   '───────────'    center("───────",w,'─')    '────'
say   center(#,11)     center(z        ,w)        right(s,4)

    do step=1   until  #==times
           do   k=1    for x-1
             do m=k+1  to  x           /*method doesn't use adjaceny.   */
             ?=
                 do n=1  for x         /*build a new permutation by swap*/
                 if n\==k & n\==m  then               ?=? || getOne(n)
                                   else if n==k  then ?=? || getOne(m)
                                                 else ?=? || getOne(k)
                 end   /*n*/
             if sep\==''  then ?=strip(?,'L',sep)
             z=?                       /*save this permute for next swap*/
             if !.?  then iterate m    /*if defined before, try next one*/
             #=#+1;  s=-s;  say  center(#,11)    center(?,w)    right(s,4)
             !.?=1
             iterate step
             end       /*m*/
           end         /*k*/
    end                /*step*/

return
