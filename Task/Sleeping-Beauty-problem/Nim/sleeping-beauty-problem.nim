import random

const N = 1_000_000

type Side {.pure.} = enum Heads, Tails

const Sides = [Heads, Tails]

randomize()
var onHeads, wakenings = 0
for _ in 1..N:
  let side = sample(Sides)
  inc wakenings
  if side == Heads:
    inc onHeads
  else:
    inc wakenings

echo "Wakenings over ", N, " experiments: ", wakenings
echo "Sleeping Beauty should estimate a credence of: ", onHeads / wakenings
