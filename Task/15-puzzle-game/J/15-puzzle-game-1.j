require'general/misc/prompt'

genboard=:3 :0
  b=. ?~16
  if. 0<C.!.2 b do.
    b=. (<0 _1)C. b
  end.
  a: (b i.0)} <"0 b
)

done=: (<"0]1+i.15),a:

shift=: |.!._"0 2
taxi=: |:,/"2(_1 1 shift i.4 4),_1 1 shift"0 1/ i.4 4

showboard=:3 :0
  echo 'current board:'
  echo 4 4$y
)

help=:0 :0

  Slide a number block into the empty space
  until you get:
┌──┬──┬──┬──┐
│1 │2 │3 │4 │
├──┼──┼──┼──┤
│5 │6 │7 │8 │
├──┼──┼──┼──┤
│9 │10│11│12│
├──┼──┼──┼──┤
│13│14│15│  │
└──┴──┴──┴──┘
  Or type 'q' to quit.
)

getmove=:3 :0
  showboard y
  blank=. y i. a:
  options=. /:~ ;y {~ _ -.~ blank { taxi
  whilst. -. n e. options do.
    echo 'Valid moves: ',":options
    t=. prompt 'move which number? '
    if. 'q' e. t do.
      echo 'giving up'
      throw.
    elseif. 'h' e. t do.
      echo help
      showboard y
    end.
    n=. {._".t
  end.
  (<blank,y i.<n) C. y
)

game=: 3 :0
  echo '15 puzzle'
  echo 'h for help, q to quit'
  board=. genboard''
  whilst. -. done-:board do.
    board=. getmove board
  end.
  showboard board
  echo 'You win.'
)
