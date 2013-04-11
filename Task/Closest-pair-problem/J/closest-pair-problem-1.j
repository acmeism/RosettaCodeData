vecl   =:  +/"1&.:*:                  NB. length of each of vectors
dist   =: <@:vecl@:({: -"1 }:)\               NB. calculate all distances among vectors
minpair=: ({~ > {.@($ #: I.@,)@:= <./@;)dist  NB. find one pair of the closest points
closestpairbf =: (; vecl@:-/)@minpair         NB. the pair and their distance
