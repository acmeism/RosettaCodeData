board=: ' ' ,.~ ' ' ,. ' ' , ' ' ,~ ]

nwS=: 3 : 0
  e=. (<1 1){y
  if. ('.'=e)*. e.&1 2 +/'H'=,y do. 'H' return. end.
  ' t..' {~ ' Ht.' i. e
)
