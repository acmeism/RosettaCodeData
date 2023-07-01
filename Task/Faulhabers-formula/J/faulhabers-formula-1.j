Bsecond=:verb define"0
  +/,(<:*(_1^[)*!*(y^~1+[)%1+])"0/~i.1x+y
)

Bfirst=: Bsecond - 1&=

Faul=:adverb define
  (0,|.(%m+1x) * (_1x&^ * !&(m+1) * Bfirst) i.1+m)&p.
)
