   <-/p:i.5            NB. a mysterious expression
┌─┐
│8│
└─┘
   <-/p:([echo)i.5     NB. show the right argument to p:
0 1 2 3 4
┌─┐
│8│
└─┘
   <-/([echo)p:i.5     NB. show the right argument to -/
2 3 5 7 11
┌─┐
│8│
└─┘
   <(-([echo))/p:i.5   NB. show the right arguments to -
11
_4
9
_6
┌─┐
│8│
└─┘
   <(-~([echo))~/p:i.5 NB. show the left arguments to -
7
5
3
2
┌─┐
│8│
└─┘
   <-&([echo)/p:i.5    NB. show both the right and left arguments to -
11
7
_4
5
9
3
_6
2
┌─┐
│8│
└─┘
   <([echo)-/p:i.5     NB. show the right argument to <
8
┌─┐
│8│
└─┘
