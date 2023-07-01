val rec printio = fn
    [] => ()
 |  s::t  => (print (s^"  :  "); print ((showHand s)^"\n") before printio t) ;

printio
[ "2h 2d 2c kc qd" ,
  "2h 5h 7d 8c 9s",
  "ah 2d 3c 4c 5d" ,
  "2h 3h 2d 3s 3d",
  "2h 7h 2d 3c 3d",
  "2h 7h 7d 7c 7s",
  "10h jh qh kh ah",
  "4h 4s ks 5d 10s",
  "qc 10c 7c 6c 4c",
  "ac ah ac ad 10h"] ;

2h 2d 2c kc qd  :  three-of-a-kind
2h 5h 7d 8c 9s  :  high-card
ah 2d 3c 4c 5d  :  straight
2h 3h 2d 3s 3d  :  full-house
2h 7h 2d 3c 3d  :  two-pair
2h 7h 7d 7c 7s  :  four-of-a-kind
10h jh qh kh ah  :  straight-flush
4h 4s ks 5d 10s  :  one-pair
qc 10c 7c 6c 4c  :  flush
ac ah ac ad 10h  :  invalid
val it = (): unit
