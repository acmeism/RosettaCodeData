/*REXX program generates all permutations of N different objects by swapping. */
parse arg things bunch .               /*get optional arguments from the C.L. */
things = p(things 4)                   /*should use the default for  THINGS ? */
bunch  = p(bunch things)               /*   "    "   "     "     "   BUNCH  ? */
call permSets things, bunch            /*invoke permutations by swapping sub. */
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────one─liner subroutines─────────────────────*/
!:  procedure;  !=1;        do j=2  to arg(1);  !=!*j;  end;         return !
c:  return substr(arg(1),arg(2),1)     /*pick a single character from a string*/
p:  return word(arg(1), 1)             /*pick 1st word (or number) from a list*/
/*──────────────────────────────────PERMSETS subroutine───────────────────────*/
permSets: procedure; parse arg x,y     /*take   X  things   Y   at a time.    */
!.=0;     pad=left('',x*y)             /*Note:  X  can't be > length(@0abcs). */
@abc ='abcdefghijklmnopqrstuvwxyz';   @abcU=@abc;  upper @abcU   /*build syms.*/
@abcS=@abcU || @abc;   @0abcS=123456789 || @abcS                 /*···and more*/
z=                                     /*define Z to be a null value for start*/
     do i=1  for x                     /*build list of (permutation) symbols. */
     z=z || c(@0abcS,i)                /*append the char to the symbol list.  */
     end   /*i*/
#=1                                    /*the number of permutations  (so far).*/
!.z=1;  q=z;  s=1;  times=!(x)% !(x-y) /*calculate (#) TIMES  using factorial.*/
w=max(length(z), length('permute'))    /*maximum width of  Z and also PERMUTE.*/
say center('permutations for '   x   ' things taken '   y   " at a time",60,'═')
say
say   pad    'permutation'    center("permute",w,'─')     'sign'
say   pad    '───────────'    center("───────",w,'─')     '────'
say   pad    center(#,11)     center(z        ,w)       right(s, 4-1)

    do $=1   until  #==times           /*perform permutation until # of times.*/
      do   k=1    for x-1              /*step thru things for  things-1 times.*/
        do m=k+1  to  x                /*this method doesn't use adjacency.   */
        ?=                             /*begin this with a blank (null) slate.*/
            do n=1  for x              /*build the new permutation by swapping*/
            if n\==k & n\==m  then               ? =   ? ||  c(z, n)
                              else if n==k  then ? =   ? ||  c(z, m)
                                            else ? =   ? ||  c(z, k)
            end   /*n*/
        z=?                            /*save this permutation for next swap. */
        if !.?  then iterate m         /*if defined before, then try next 'un.*/
        _=0                            /* [↓]  count number of swapped symbols*/
            do d=1  for x  while $\==1;   _=_+(c(?,d)\==c(prev,d));   end  /*d*/
        if _>2  then do;         _=z
                     a=$//x+1;   q=q+_ /* [← ↓]  this swapping tries adjacency*/
                     b=q//x+1;   if b==a  then b=a+1;   if b>x  then b=a-1
                     z=overlay(c(z,b), overlay(c(z,a), _, b),  a)
                     iterate $         /*now, try this particular permutation.*/
                     end
        #=#+1;  s=-s;    say pad   center(#,11)     center(?,w)     right(s,4-1)
        !.?=1;  prev=?;      iterate $ /*now, try another swapped permutation.*/
        end   /*m*/
      end     /*k*/
    end       /*$*/
return                                 /*we're all finished with permutating. */
