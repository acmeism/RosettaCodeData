tpk=: 3 :0
  smoutput 'Enter 11 numbers: '
  t1=: ((5 * ^&3) + (^&0.5@* *))"0 |. _999&".;._1 ' ' , 1!:1 [ 1
  smoutput 'Values of functions of reversed input: ' , ": t1
  ; <@(,&' ')@": ` ((<'user alert ')&[) @. (>&400)"0 t1
)
