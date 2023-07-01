Josephus =: dyad define NB. explicit form, assume executioner starts at position 0
 NB. use:  SKIP josephus NUMBER_OF_PRISONERS
 N =: y
 K =: N | x
 EXECUTIONER =: 0
 PRISONERS =: i. N
 kill =: ] #~ (~: ([: i. #))
 while. 1 (< #) PRISONERS do.
  EXECUTIONER =: (# PRISONERS) | <: K + EXECUTIONER
  PRISONERS =: EXECUTIONER kill PRISONERS
 end.
)

   3 Josephus 41
30
