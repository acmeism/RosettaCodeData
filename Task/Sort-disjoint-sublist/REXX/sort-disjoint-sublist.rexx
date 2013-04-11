/*REXX program uses a strand sort to sort a random list of words | nums.*/
parse arg old ',' idx                  /*get options from command line. */
if old=''  then old=7 6 5 4 3 2 1 0    /*no list?  Then use the default.*/
if idx=''  then idx=7 2 8              /*no idxs?    "   "   "     "    */
old=space(old)                         /*remove any extraneous blanks.  */
say 'list of indices:' idx
idx=sortL(idx)                         /*ensure the index list is sorted*/
say
say '  unsorted list:' old
                       new=disjoint_sort(old,idx)             /*sort it.*/
say '    sorted list:' new
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DISJOINT_SORT subroutine────────────*/
disjoint_sort: procedure;  parse arg x,indL;  y=;  z=;  p=0
              do i=1  for words(indL)  /*extract indexed values from  X.*/
              z=z word(x,word(indL,i))
              end   /*j*/
z=sortL(z)                             /*sort extracted (indexed) values*/
                 do m=1  for words(x)  /*re-build (re-populate)  X list.*/
                 if wordpos(m,indL)==0  then y=y word(x,m)  /*same | new?*/
                                        else do; p=p+1; y=y word(z,p); end
                 end   /*m*/
return strip(y)
/*──────────────────────────────────SORTL subroutine────────────────────*/
sortL: procedure; parse arg L; n=words(L); do j=1 for n; @.j=word(L,j); end
  do k=1  to n-1                       /*sort index list the slow way.  */
    do m=k+1  to n;  if @.m<@.k then parse value @.k @.m with @.m @.k;  end
  end   /*k*/
s=@.1;               do j=2  to n;  s=s @.j;  end;            return s
