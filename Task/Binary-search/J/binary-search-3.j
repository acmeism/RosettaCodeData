'X Y L H M'=. i.5                            NB. Setting mnemonics for boxes
f=. &({::)                                   NB. Fetching the contents of a box
o=. @:                                       NB. Composing verbs (functions)

boxes=. ; , a: $~ 3:                         NB. Appending 3 (empty) boxes to the inputs
LowHigh=. (0 ; # o (X f)) (L,H)} ]           NB. Setting the low and high bounds
midpoint=. < o (<. o (2 %~ L f + H f)) M} ]  NB. Updating the midpoint
case=.     >: o * o (Y f - M f { X f)        NB. Less=0, equal=1, or greater=2

squeeze=. (< o (_1 + M f) H} ])`(< o _: L} ])`(< o (1 + M f) L} ])@.case
return=.   (M f) o ((<@:('Not Found'"_) M} ]) ^: (_ ~: L f))

bs=. return o (squeeze o midpoint ^: (L f <: H f) ^:_) o LowHigh o boxes
