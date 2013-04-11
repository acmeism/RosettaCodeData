require'misc'

poss=:1+~.4{."1 (i.!9)A.i.9
fmt=: ' ' -.~ ":

play=:3 :0
  while.1<#poss=.poss do.
    smoutput'guessing ',fmt guess=.({~ ?@#)poss
    bc=.+/\_".prompt 'how many bull and cows? '
    poss=.poss #~({.bc)=guess+/@:="1 poss
    poss=.poss #~({:bc)=guess+/@e."1 poss
  end.
  if.#poss do.
    'the answer is ',fmt,poss
  else.
    'no valid possibilities'
  end.
)
