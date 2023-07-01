flip=: C.~ C.@i.@-
unsorted=: #~ 1 , [: >./\. 2 >/\ ]
FlDown=: flip 1 + (i. >./)@unsorted
FlipUp=: flip 1 >. [:+/>./\&|.@(< {.)

pancake=: FlipUp@FlDown^:_
