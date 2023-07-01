# Knapsack unbounded. Brute force solution.

import lenientops   # Mixed float/int operators.
import strformat

type Bounty = tuple[value: int; weight, volume: float]

const
  Panacea: Bounty = (value: 3000, weight: 0.3, volume: 0.025)
  Ichor: Bounty = (value: 1800, weight: 0.2, volume: 0.015)
  Gold: Bounty = (value: 2500, weight: 2.0, volume: 0.002)
  Sack: Bounty = (value: 0, weight: 25.0, volume: 0.25)

  MaxPanacea = min(Sack.weight / Panacea.weight, Sack.volume / Panacea.volume).toInt
  MaxIchor = min(Sack.weight / Ichor.weight, Sack.volume / Ichor.volume).toInt
  MaxGold = min(Sack.weight / Gold.weight, Sack.volume / Gold.volume).toInt

var
  totalWeight, totalVolume: float
  n: array[1..3, int]   # Number of panacea, ichor and gold.
  maxValue = 0

for i in 0..MaxPanacea:
  for j in 0..MaxIchor:
    for k in 0..MaxGold:
      var current: Bounty
      current.value =  k * Gold.value  + j * Ichor.value  + i * Panacea.value
      current.weight = k * Gold.weight + j * Ichor.weight + i * Panacea.weight
      current.volume = k * Gold.volume + j * Ichor.volume + i * Panacea.volume
      if current.value > maxValue and current.weight <= Sack.weight and current.volume <= Sack.volume:
        maxvalue = current.value
        totalweight = current.weight
        totalvolume = current.volume
        n = [i, j, k]

echo fmt"Maximum value achievable is {maxValue}."
echo fmt"This is achieved by carrying {n[1]} panacea, {n[2]} ichor and {n[3]} gold items."
echo fmt"The weight of this carry is {totalWeight:6.3f} and the volume used is {totalVolume:6.4f}."
