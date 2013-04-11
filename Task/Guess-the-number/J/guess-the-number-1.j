require 'misc'
game=: verb define
  n=: 1 + ?10
  smoutput 'Guess my integer, which is bounded by 1 and 10'
  whilst. -. guess -: n do.
    guess=. {. 0 ". prompt 'Guess: '
    if. 0 -: guess do. 'Giving up.' return. end.
    smoutput (guess=n){::'no.';'Well guessed!'
  end.
)
