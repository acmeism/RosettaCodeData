import std/[algorithm, strutils, sugar, tables]

func moreMultiples(toSeq, fromSeq: seq[int]): seq[seq[int]] =
  ## Uses the first definition and recursion to generate the sequences.
  result = collect:
             for i in fromSeq:
               if i > toSeq[^1] and i mod toSeq[^1] == 0:
                 toSeq & i

  for i in 0..result.high:
    for arr in moreMultiples(result[i], fromSeq):
      result.add arr

func divisors(n: int): seq[int] =
  ## Return the list of divisors of "n".
  var d = 1
  while d * d <= n:
    if n mod d == 0:
      let q = n div d
      result.add d
      if q != d:
        result.add q
    inc d
  result.sort()

func cmp(x, y: seq[int]): int =
  ## Compare two sequences.
  for i in 0..<min(x.len, y.len):
    result = cmp(x[i], y[i])
    if result != 0: return
  result = cmp(x.len, y.len)

let listing = collect(
                for a in sorted(moreMultiples(@[1], divisors(48)[1..^2]), cmp):
                  a & 48) & @[@[1, 48]]

echo "48 sequences using first definition:"
for i, s in listing:
  let item = '[' & s.join(", ") & ']'
  stdout.write alignLeft(item, 22)
  stdout.write if i mod 4 == 3: '\n' else: ' '

# Derive second definition's sequences
echo "\n48 sequences using second definition:"

for i, s1 in listing:
  let s2 = collect:
             for j in 1..s1.high:
               s1[j] div s1[j - 1]
  let item = '[' & s2.join(", ") & ']'
  stdout.write alignLeft(item, 20)
  stdout.write if i mod 4 == 3: '\n' else: ' '

var cache: Table[int, int]

proc erdosFactorCount(n: int): int =
  ## Erdos method.
  if n in cache: return cache[n]
  let ds = divisors(n)
  if ds.len >= 2:
    for d in ds[1..^2]:
      result += erdosFactorCount(n div d)
  inc result
  cache[n] = result

stdout.write "\nOEIS A163272: "
let s = collect:
          for num in 0..<2_400_000:
            if num == 0 or erdosFactorCount(num) == num:
              num
echo s.join(", ")
