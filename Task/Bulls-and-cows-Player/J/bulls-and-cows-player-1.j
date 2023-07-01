require'general/misc/prompt'
poss=:1+~.4{."1 (i.!9)A.i.9
fmt=: ' ' -.~ ":

play=: {{
  while.1<#poss=.poss do.
    echo 'guessing ',fmt guess=.({~ ?@#)poss
    bc=. _".prompt 'how many bull and cows? '
    poss=.poss #~({.bc)=guess+/@:="1 poss
    poss=.poss #~(+/bc)=guess+/@e."1 poss
  end.
  if.#poss do.
    'the answer is ',fmt,poss
  else.
    'no valid possibilities'
  end.
}}
