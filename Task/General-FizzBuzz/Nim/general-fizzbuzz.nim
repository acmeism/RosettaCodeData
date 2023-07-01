import parseutils, strutils, algorithm

type FactorAndWord = tuple[factor:int, word: string]

var number: int
var factorAndWords: array[3, FactorAndWord]

#custom comparison proc for the FactorAndWord type
proc customCmp(x,y: FactorAndWord): int =
  if x.factor < y.factor:
    -1
  elif x.factor > y.factor:
    1
  else:
    0

echo "Enter max number:"
var input = readLine(stdin)
discard parseInt(input, number)

for i in 0..2:

  echo "Enter a number and word separated by space:"
  var input = readLine(stdin)

  var tokens = input.split
  discard parseInt(tokens[0], factorAndWords[i].factor)
  factorAndWords[i].word = tokens[1]

#sort factors in ascending order
sort(factorAndWords, customCmp)

#implement fiz buz
for i in 1..number:
  var written = false;
  for item in items(factorAndWords):
    if i mod item.factor == 0 :
      write(stdout, item.word)
      written = true
  if written :
    write(stdout, "\n")
  else :
    writeLine(stdout, i)
