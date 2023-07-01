USE: math.ranges

:: exchange-count ( seq val -- cnt )
  val 1 + 0 <array> :> tab
  0 :> old!
  1 0 tab set-nth
  seq length iota [
    seq nth old!
    old val [a,b] [| j |
      j old - tab nth
      j tab nth +
      j tab set-nth
    ] each
  ] each
  val tab nth
;

[ { 1 5 10 25 50 100 } 100000 exchange-count . ] time
13398445413854501
Running time: 0.029163549 seconds
