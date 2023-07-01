BREAKLOOP
 NEW A,B
 SET A=""
 FOR  Q:A=10  DO
 .SET A=$RANDOM(20)
 .WRITE !,A
 .Q:A=10
 .SET B=$RANDOM(20)
 .WRITE ?6,B
 KILL A,B
 QUIT
 ;A denser version that doesn't require two tests
 NEW A,B
 FOR  SET A=$RANDOM(20) WRITE !,A QUIT:A=10  SET B=$RANDOM(20) WRITE ?6,B
 KILL A,B QUIT
