'X Y L H M'=. i.5                            NB. Setting mnemonics for boxes
f=. &({::)                                   NB. Fetching the contents of a box
o=. @:                                       NB. Composing verbs (functions)

boxes=. a: ,~ ;                              NB. Appending 1 (empty) box to the inputs
midpoint=. < o (<. o (2 %~ L f + H f)) M} ]  NB. Updating the midpoint
case=.     >: o * o (Y f - M f { X f)        NB. Less=0, equal=1, or greater=2

recur=. (X f bs Y f ; L f ; (_1 + M f))`(M f)`(X f bs Y f ; (1 + M f) ; H f)@.case

bs=. (recur o midpoint`('Not Found'"_) @. (H f < L f) o boxes) :: ([ bs ] ; 0 ; (<: o # o [))
