|val|
val := 0.
[
  val := val + 1.
  val displayNl.
] doWhile: [ (val rem: 6) ~= 0 ]
