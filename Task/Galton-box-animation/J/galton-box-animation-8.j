pins=: '*'&=
balls=: 'o'&=

bounce=: (C.~ 0 1 <@(-/~) [: (+ ?@2:"0) I.)"1

nxt=: ' ',~ [: clean ' *o' {~ pins + 2 * _1 shift balls bounce balls *. 1 shift pins

clean2=: ({. , -.&' '"1&.|:&.|.@}.)~ 1 + >./@(# | '*' i:~"1 |:)
clean1=: #~ 1 1 -.@E. *./"1@:=&' '
clean=: clean1@clean2
