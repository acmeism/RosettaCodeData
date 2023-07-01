require 'files'

readppm=: monad define
  dat=. fread y                                           NB. read from file
  msk=. 1 ,~ (*. 3 >: +/\) (LF&=@}: *. '#'&~:@}.) dat     NB. mark field ends
  't wbyh maxval dat'=. msk <;._2 dat                     NB. parse
  'wbyh maxval'=. 2 1([ {. [: _99&". (LF,' ')&charsub)&.> wbyh;maxval  NB. convert to numeric
  if. (_99 0 +./@e. wbyh,maxval) +. 'P6' -.@-: 2{.t do. _1 return. end.
  (a. i. dat) makeRGB |.wbyh                              NB. convert to basic bitmap format
)
