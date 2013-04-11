checkUniform=: adverb define
  0.05 u checkUniform y
  :
  n=. */y
  delta=. x
  sample=. u n              NB. the "u" refers to the verb to left of adverb
  freqtable=. /:~ (~. sample) ,. #/.~ sample
  expected=. n % # freqtable
  errmsg=. 'Distribution is potentially skewed'
  errmsg assert (delta * expected) > | expected - {:"1 freqtable
  freqtable
)
