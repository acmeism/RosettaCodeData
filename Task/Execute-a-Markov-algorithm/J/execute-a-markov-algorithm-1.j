require'strings regex'

markovLexer =:  verb define
  rules =.  LF cut TAB&=`(,:&' ')}y
  rules =.  a: -.~ (dltb@:{.~ i:&'#')&.> rules
  rules =.  0 _1 {"1 '\s+->\s+' (rxmatch rxcut ])S:0 rules
  (,. ] (}.&.>~ ,. ]) ('.'={.)&.>)/ |: rules
)


replace     =:  dyad define
  'index patternLength replacement'=.  x
  'head tail' =.  index split y
  head, replacement, patternLength }. tail
)

matches     =:  E. i. 1:

markov      =:  dyad define
  ruleIdx =. 0 [ rules =.  markovLexer x
  while. ruleIdx < #rules do.
    'pattern replacement terminating' =. ruleIdx { rules
    ruleIdx =. 1 + ruleIdx
    if. (#y) > index =. pattern matches y do.
      y =. (index ; (#pattern) ; replacement) replace y
      ruleIdx =. _ * terminating
    end.
  end.
  y
)
