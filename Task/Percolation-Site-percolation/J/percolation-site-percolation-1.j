groups=:[: +/\ 2 </\ 0 , *
ooze=: [ >. [ +&* [ * [: ; groups@[ <@(* * 2 < >./)/. +
percolate=: ooze/\.@|.^:2^:_@(* (1 + # {. 1:))

trial=: percolate@([ >: ]?@$0:)
simulate=: %@[ * [: +/ (2 e. {:)@trial&15 15"0@#
