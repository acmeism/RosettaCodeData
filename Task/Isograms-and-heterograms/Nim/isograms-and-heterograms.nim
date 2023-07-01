import std/[algorithm, strutils, tables]

type Item = tuple[word: string; n: int]

func isogramCount(word: string): Natural =
  ## Check if the word is an isogram and return the number
  ## of times each character is present. Return 1 for
  ## heterograms. Return 0 if the word is neither an isogram
  ## or an heterogram.
  let counts = word.toCountTable
  result = 0
  for count in counts.values:
    if result == 0:
      result = count
    elif count != result:
      return 0

proc cmp1(item1, item2: Item): int =
  ## Comparison function for part 1.
  result = cmp(item2.n, item1.n)
  if result == 0:
    result = cmp(item2.word.len, item1.word.len)
    if result == 0:
      result = cmp(item1.word, item2.word)

proc cmp2(item1, item2: Item): int =
  ## Comparison function for part 2.
  result = cmp(item1.n, item2.n)
  if result == 0:
    result = cmp(item2.word.len, item1.word.len)
    if result == 0:
      result = cmp(item1.word, item2.word)


var isograms: seq[Item]

for line in lines("unixdict.txt"):
  let word = line.toLower
  let count = word.isogramCount
  if count != 0:
    isograms.add (word, count)

echo "N-isograms where N > 1:"
isograms.sort(cmp1)
var idx = 0
for item in isograms:
  if item.n == 1: break
  inc idx
  stdout.write item.word.alignLeft(12)
  if idx mod 6 == 0: stdout.write '\n'
echo()

echo "\nHeterograms with more than 10 characters:"
isograms.sort(cmp2)
idx = 0
for item in isograms:
  if item.n != 1: break
  if item.word.len > 10:
    inc idx
    stdout.write item.word.alignLeft(16)
    if idx mod 4 == 0: stdout.write '\n'
echo()
