import random

const
  Target = "METHINKS IT IS LIKE A WEASEL"
  Alphabet = " ABCDEFGHIJLKLMNOPQRSTUVWXYZ"
  P = 0.05
  C = 100

proc negFitness(trial: string): int =
  for i in 0 .. trial.high:
    if Target[i] != trial[i]:
      inc result

proc mutate(parent: string): string =
  for c in parent:
    result.add (if rand(1.0) < P: sample(Alphabet) else: c)

randomize()

var parent = ""
for _ in 1..Target.len:
  parent.add sample(Alphabet)

var i = 0
while parent != Target:
  var copies = newSeq[string](C)
  for i in 0 .. copies.high:
    copies[i] = parent.mutate()

  var best = copies[0]
  for i in 1 .. copies.high:
    if negFitness(copies[i]) < negFitness(best):
      best = copies[i]
  parent = best

  echo i, " ", parent
  inc i
