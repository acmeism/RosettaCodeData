import algorithm, sequtils, sets, strutils, tables

var cache: Table[seq[char], int]   # Maps key -> number of iterations.


iterator sequence(seed: string): string =
  ## Yield the successive strings of a sequence.

  var history: HashSet[string]
  history.incl seed
  var current = seed
  yield current

  while true:
    var counts = current.toCountTable()
    var next: string
    for ch in sorted(toSeq(counts.keys), Descending):
      next.add $counts[ch] & ch
    if next in history: break
    current = move(next)
    history.incl current
    yield current


proc seqLength(seed: string): int =
  ## Return the number of iterations for the given seed.
  let key = sorted(seed, Descending)
  if key in cache: return cache[key]
  result = toSeq(sequence(seed)).len
  cache[key] = result


var seeds: seq[int]
var itermax = 0
for seed in 0..<1_000_000:
  let itercount = seqLength($seed)
  if itercount > itermax:
    itermax = itercount
    seeds = @[seed]
  elif itercount == itermax:
    seeds.add seed

echo "Maximum iterations: ", itermax
echo "Seed values: ", seeds.join(", ")
echo "Sequence for $#:".format(seeds[0])
for s in sequence($seeds[0]): echo s
