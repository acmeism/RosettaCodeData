/*REXX program generates all permutations of  N  different objects.     */
parse arg things bunch inbetweenChars names

      /* inbetweenChars  (optional)   defaults to a  [null].            */
      /*          names  (optional)   defaults to digits (and letters). */

call permSets things,bunch,inbetweenChars,names
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────.PERMSET subroutine─────────────────*/
.permset:  procedure expose (list);    parse arg ?
if ?>y then do; _=@.1;   do j=2 to y; _=_||between||@.j; end;   say _; end
       else do q=1 for x               /*build permutation recursively. */
                do k=1 for ?-1;  if @.k==$.q then iterate q;  end    /*k*/
            @.?=$.q;      call .permset ?+1
            end    /*q*/
return
/*──────────────────────────────────PERMSETS subroutine─────────────────*/
permSets: procedure; parse arg x,y,between,uSyms /*X things Y at a time.*/
@.=;   sep=                            /*X  can't be > length(@0abcs).  */
@abc  = 'abcdefghijklmnopqrstuvwxyz';     @abcU=@abc;         upper @abcU
@abcS = @abcU || @abc;                    @0abcS=123456789 || @abcS

  do k=1 for x                         /*build a list of (perm) symbols.*/
  _=p(word(uSyms,k)  p(substr(@0abcS,k,1) k))   /*get|generate a symbol.*/
  if length(_)\==1  then sep='_'       /*if not 1st char, then use sep. */
  $.k=_                                /*append it to the symbol list.  */
  end

if between==''  then between=sep       /*use the appropriate separator. */
list='$. @. between x y'
call .permset 1
return
/*──────────────────────────────────P subroutine (Pick one)─────────────*/
p:  return word(arg(1),1)
