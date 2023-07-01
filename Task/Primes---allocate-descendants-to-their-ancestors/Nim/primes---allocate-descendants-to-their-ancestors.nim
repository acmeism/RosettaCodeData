import algorithm, strformat, strutils, sugar

const MaxSum = 99

func getPrimes(max: Positive): seq[int] =
  if max < 2: return
  result.add 2
  for n in countup(3, max, 2):
    block check:
      for p in result:
        if n mod p == 0:
          break check
      result.add n

let primes = getPrimes(MaxSum)

var descendants, ancestors = newSeq[seq[int]](MaxSum + 1)

for p in primes:
  descendants[p].add p
  for s in 1..(descendants.high - p):
    descendants[s + p].add collect(newSeq, for pr in descendants[s]: p * pr)

for p in primes & 4:
  discard descendants[p].pop()

var total = 0
for s in 1..MaxSum:
  descendants[s].sort()
  for d in descendants[s]:
    if d > MaxSum: break
    ancestors[d] = ancestors[s] & s
  let dlength = descendants[s].len
  echo &"[{s}] Level: {ancestors[s].len}"
  echo "Ancestors: ", if ancestors[s].len != 0: ancestors[s].join(" ") else: "None"
  echo "Descendants: ", if dlength != 0: $dlength else: "None"
  if dlength != 0: echo descendants[s].join(", ")
  echo ""
  inc total, dlength

echo "Total descendants: ", total
