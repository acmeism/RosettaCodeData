upcdigit=:".;._2]0 :0
  0 0 0 1 1 0 1 NB. 0
  0 0 1 1 0 0 1 NB. 1
  0 0 1 0 0 1 1 NB. 2
  0 1 1 1 1 0 1 NB. 3
  0 1 0 0 0 1 1 NB. 4
  0 1 1 0 0 0 1 NB. 5
  0 1 0 1 1 1 1 NB. 6
  0 1 1 1 0 1 1 NB. 7
  0 1 1 0 1 1 1 NB. 8
  0 0 0 1 0 1 1 NB. 9
)

upc2dec=:3 :0
  if. 95~: #code=. '#'=dtb dlb y do._ return.end.
  if. (11$1 0) ~: 0 1 2 45 46 47 48 49 92 93 94{ code do._ return. end.
  digits=. <./([:,upcdigit i.0 1~:(3 50+/i.6 7) {  ])"1 code,:|.code
  if. 10 e.digits do._ return.end.
  if.0 ~:10|digits+/ .* 12$3 1 do._ return.end.
)
