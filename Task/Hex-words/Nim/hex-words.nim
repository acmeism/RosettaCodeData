import std/[algorithm, setutils, strformat, strutils]

const LowerHexDigits = {'a'..'f'}

type Item = tuple[word: string; value, droot: int]

iterator digits(n: Natural): Natural =
  ## Yield the digits of a natural.
  var n = n
  while true:
    yield n mod 10
    n = n div 10
    if n == 0:
      break

func digitalRoot(n: Natural): Natural =
  ## Return the digital root of a natural.
  var n = n
  while true:
    result = 0
    for d in n.digits:
      result += d
    if result <= 9:
      break
    n = result

proc display(items: seq[Item]) =
  ## Display the items.
  echo "Word     Decimal value   Digital root"
  echo repeat("─", 39)
  for item in items:
    echo &"{item.word:<8}{item.value:>12}{item.droot:12}"
  echo "\nTotal count: ", items.len

# Build the list of items.
var items: seq[Item]
for word in lines("unixdict.txt"):
  if word.len >= 4 and card(word.toSet - LowerHexDigits) == 0:
    let val = word.parseHexInt()
    items.add (word, val, val.digitalRoot)

# Sort the items by increasing digital root and display the result.
echo "Hex words in “unixdict.txt”:\n"
items = items.sortedByIt(it.droot)
items.display()

# Remove the items with less than 4 distinct letters.
for i in countdown(items.high, 0):
  if card(items[i].word.toSet) < 4:
    items.delete i

# Sort the items by decreasing value and display the result.
echo "\n\nHex words with more than three distinct letters:\n"
items = items.sortedByIt(-it.value)
items.display()
