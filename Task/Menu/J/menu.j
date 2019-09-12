CHOICES =: ];._2 'fee fie;huff and puff;mirror mirror;tick tock;'
PROMPT =: 'Which is from the three pigs? '

showMenu =: smoutput@:(,"1~ (' ' ,.~ 3 ": i.@:(1 ,~ #)))
read_stdin =: 1!:1@:1:

menu =: '? '&$: :(4 : 0)
 NB. use:  [prompt] menu choice_array
 CHOICES =. y
 if. 0 = # CHOICES do. return. end.
 PROMPT =. x
 whilst. RESULT -.@:e. i. # CHOICES do.
  showMenu CHOICES
  smoutput PROMPT
  RESULT =. _1 ". read_stdin''
 end.
 RESULT {:: CHOICES
)
