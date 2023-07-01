p=: adverb define
:
 el =. x
 en =. y
 pwr =. m
 el =. <. | el
 digitcount =. <. 10 ^. el
 log10pwr =. 10 ^. pwr
 'raised found' =. _1 0
 while. found < en do.
  raised =. >: raised
  firstdigits =. (<.!.0) 10^digitcount + 1 | log10pwr * raised
  found =. found + firstdigits = el
 end.
 raised
)
