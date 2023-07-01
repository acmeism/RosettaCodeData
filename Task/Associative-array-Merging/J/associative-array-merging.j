merge=: ,.    NB. use: update merge original
compress=: #"1~ ~:@:keys
keys=: {.
values=: {:
get=: [: > ((i.~ keys)~ <)~ { values@:]   NB. key get (associative array)
pair=: [: |: <;._2;._2
