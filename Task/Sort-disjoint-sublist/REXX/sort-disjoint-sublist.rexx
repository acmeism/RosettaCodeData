/*REXX program uses a disjointed sublist to sort a random list of values*/
parse arg old ',' idx                  /*get lists from the command line*/
if old=''  then old=7 6 5 4 3 2 1 0    /*No  old?  Then use the default.*/
if idx=''  then idx=7 2 8              /* "  idx?    "   "   "     "    */
say '  list of indices:'  idx;   say   /*    [↑]  is for one─based lists*/
say '    unsorted list:'  old                        /*display old list.*/
say '      sorted list:'  disjoint_sort(old, idx)    /*sort, display it.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DISJOINT_SORT subroutine────────────*/
disjoint_sort:  procedure;   parse arg x,ix;    y=;    z=;    p=0
ix=sortL(ix)                           /*ensure the index list is sorted*/
             do i=1  for  words(ix)    /*extract indexed values from  X.*/
             z=z word(x, word(ix, i))  /*pick the correct value from  X.*/
             end   /*j*/
z=sortL(z)                             /*sort extracted (indexed) values*/
                do m=1  for words(x)   /*re-build (re-populate)  X list.*/
                if wordpos(m,ix)==0  then y=y word(x,m)    /*same | new?*/
                                     else do;  p=p+1;  y=y word(z,p);  end
                end   /*m*/
return strip(y)
/*──────────────────────────────────SORTL subroutine────────────────────*/
sortL: procedure; parse arg L; n=words(L); do j=1 for n; @.j=word(L,j);end
  do k=1  for n-1                      /*sort a list using a slow method*/
    do m=k+1  to n; if @.m<@.k  then parse value @.k @.m with @.m @.k; end
  end   /*k*/                          /* [↑]  use  PARSE  for swapping.*/
$=@.1;               do j=2  to n;   $=$ @.j;  end;            return $
