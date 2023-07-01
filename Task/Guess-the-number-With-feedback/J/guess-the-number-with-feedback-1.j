require 'misc'
game=: verb define
  assert. y -: 1 >. <.{.y
  n=: 1 + ?y
  smoutput 'Guess my integer, which is bounded by 1 and ',":y
  whilst. -. x -: n do.
    x=. {. 0 ". prompt 'Guess: '
    if. 0 -: x do. 'Giving up.' return. end.
    smoutput (*x-n){::'You win.';'Too high.';'Too low.'
  end.
)
