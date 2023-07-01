s='rosetta code phrase reversal'
r1=reverse(s)
r2=''
Do i=1 To words(s)
  r2=r2 reverse(word(s,i))
  End
r2=strip(r2)
r3=''
Do i=words(s) To 1 By -1
  r3=r3 word(s,i)
  End
r3=strip(r3)
Say "input               : " s
say "string reversed     : " r1
say "each word reversed  : " r2
say "word-order reversed : " r3
