include FMS-SI.f
include FMS-SILib.f

var x  \ instantiate a class var object named x

: test
  heap> string locals| s |
  '!' s +: ':' s +:  \ build the message "!:" into string s
  42 x s @: evaluate \ retrieve the text from s and execute it
  x p: ; \ lastly, send the p: message to x to print it

test \ => 42 ok
