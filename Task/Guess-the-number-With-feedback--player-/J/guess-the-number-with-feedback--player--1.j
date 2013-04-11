require 'misc'
guess=:3 :0
  'lo hi'=.y
  while.lo < hi do.
    smoutput 'guessing a number between ',(":lo),' and ',":hi
    guess=.lo+?hi-lo
    select.{.deb tolower prompt 'is it ',(":guess),'? '
      case.'y'do. smoutput 'Win!' return.
      case.'l'do. lo=.guess+1
      case.'h'do. hi=.guess-1
      case.'q'do. smoutput 'giving up' return.
      case.   do. smouput 'options: yes, low, high, quit'
    end.
  end.
)
