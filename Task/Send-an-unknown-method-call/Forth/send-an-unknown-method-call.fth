include FMS-SI.f
include FMS-SILib.f

var x  \ instantiate a class var object named x

\ Use a standard Forth string and evaluate it.
\ This is equivalent to sending the !: message to object x
42 x  s" !:"  evaluate

x p: 42     \ send the print message ( p: ) to x to verify the contents
