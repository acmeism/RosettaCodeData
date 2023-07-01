|val|
val := 0.
[
  val := val + 1.
  val displayNl.
] doUntil: [ (val rem: 6) == 0 ]
