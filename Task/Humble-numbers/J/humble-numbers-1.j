humble=: 4 : 0
 NB. x humble y  generates x humble numbers based on factors y
 result=. , 1
 while. x > # result do.
  a=. , result */ y
  result=. result , <./ a #~ a > {: result
 end.
)
