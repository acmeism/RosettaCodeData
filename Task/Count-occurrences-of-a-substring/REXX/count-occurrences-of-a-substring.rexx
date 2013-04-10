/*REXX program: use a subroutine that counts occurrences of a substring.*/
bag = "the three truths"
  x = "th"
                       say left(bag,30) left(x,15) 'found' countstr(bag,x)
bag = "ababababab"
  x = "abab"
                       say left(bag,30) left(x,15) 'found' countstr(bag,x)
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────COUNTSTR subroutine──────────────*/
countstr:  procedure;    parse arg haystack, needle, startAt
if startAt=='' then startAt=1;              width=length(needle)
                   do k=0  until _==0;      _=pos(needle,haystack,startAt)
                   startAt = _ + width
                   end   /*k*/
return k
