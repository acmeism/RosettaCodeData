checkUniformT=: adverb define
  0.05 u checkUniformT y
  :
  freqtable=. /:~ (~. ,. #/.~) u n=. */y
  errmsg=. 'Distribution is potentially skewed'
  errmsg assert ((n % #) (x&*@[ > |@:-) {:"1) freqtable
  freqtable
)
