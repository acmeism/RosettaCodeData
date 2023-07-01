isPalin=: -: |.                          NB. check if palindrome
toBase=: #.inv"0                         NB. convert to base(s) in left arg
filterPalinBase=: ] #~ isPalin@toBase/   NB. palindromes for base(s)
find23Palindromes=: 3 filterPalinBase 2 filterPalinBase ]  NB. palindromes in both base 2 and base 3

showBases=: [: ;:inv@|: <@({&'0123456789ABCDEFGH')@toBase/ NB. display numbers in bases

NB.*getfirst a Adverb to get first y items returned by verb u
getfirst=: adverb define
  100000x u getfirst y
:
  res=. 0$0
  start=. 0
  blk=. i.x
  whilst. y > #res do.
    tmp=. u start + blk
    start=. start + x
    res=. res, tmp
  end.
  y{.res
)
