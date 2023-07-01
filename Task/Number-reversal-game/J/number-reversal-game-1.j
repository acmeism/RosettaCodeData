require 'misc'                      NB. for the verb prompt

INTRO=: noun define
Number Reversal Game
Flip groups of numbers from the left of the list until
the numbers are sorted in ascending order.
)

reversegame=: verb define
  whilst. (-: /:~)nums do.
    nums=. 1+9?9                    NB. 1-9 in random order
  end.
  score=. 0
  smoutput INTRO                    NB. Display instructions
  while. -.(-: /:~)nums do.
    score=. 1+ score                NB. increment score
    nnum=. 0".prompt (":score),': ',(":nums),' How many numbers to flip?: '
    if. 0 = #nnum do. return. end.  NB. exit on ENTER without number
    nums=. (C.i.-nnum) C. nums      NB. reverse first nnum numbers
  end.
  'You took ',(": score), ' attempts to put the numbers in order.'
)
