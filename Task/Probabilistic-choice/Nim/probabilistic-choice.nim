import tables, random, strformat, times

var start = cpuTime()

const
  NumTrials = 1_000_000
  Probabilities = {"aleph": 1 / 5, "beth": 1 / 6, "gimel": 1 / 7, "daleth": 1 / 8,
                   "he": 1 / 9, "waw": 1 / 10, "zayin": 1 / 11, "heth": 1759 / 27720}.toTable

var samples: CountTable[string]

randomize()

for i in 1 .. NumTrials:
  var z = rand(1.0)
  for item, prob in Probabilities.pairs:
    if z < prob:
      samples.inc(item)
      break
    else:
      z -= prob

var s1, s2 = 0.0

echo " Item    Target     Results   Differences"
echo "======  ========   ========   ==========="
for item, prob in Probabilities.pairs:
  let r = samples[item] / NumTrials
  s1 += r * 100
  s2 += prob * 100
  echo &"{item:<6}  {prob:.6f}   {r:.6f}   {100 * (1 - r / prob):9.6f} %"
echo "======  ========   ======== "
echo &"Total:  {s2:^8.2f}   {s1:^8.2f}"
echo &"\nExecution time: {cpuTime()-start:.2f} s"
