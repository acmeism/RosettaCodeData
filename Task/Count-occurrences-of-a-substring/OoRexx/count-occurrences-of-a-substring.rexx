 bag="the three truths"
 x="th"
 say left(bag,30) left(x,15) 'found' bag~countstr(x)

 bag="ababababab"
 x="abab"
 say left(bag,30) left(x,15) 'found' bag~countstr(x)

 -- can be done caselessly too
 bag="abABAbaBab"
 x="abab"
 say left(bag,30) left(x,15) 'found' bag~caselesscountstr(x)
