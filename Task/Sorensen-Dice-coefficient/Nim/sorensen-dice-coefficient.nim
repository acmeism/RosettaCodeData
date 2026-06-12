import std/[algorithm, strutils, sugar, tables]

func bigrams(text: string): CountTable[string] =
  ## Extract the bigrams from a text.
  for word in text.toLower.split(' '):
    if word.len == 1:
      result.inc(word)
    else:
      for i in 0..(word.len - 2):
        result.inc(word[i..(i+1)])

func intersectionCount(a, b: CountTable[string]): int =
  ## Compute the cardinal of the intersection of two
  ## count tables.
  for key, count in a:
    if key in b:
      inc result, min(count, b[key])

func card(a: CountTable[string]): int =
  ## Return the cardinal of a count table (i.e. the sum of counts).
  for count in a.values:
    inc result, count

func sorensenDice(text1, text2: string): float =
  ## Compute the Sorensen-dice coefficient of "text1" and "text2".
  let ct1 = text1.bigrams
  let ct2 = text2.bigrams
  result = 2 * intersectionCount(ct1, ct2) / (ct1.card + ct2.card)

# Build the list of tasks.
let tasks = collect:
              for line in lines("Sorensen-Dice.txt"):
                line

const Tests = ["Primordial primes", "Sunkist-Giuliani formula",
               "Sieve of Euripides", "Chowder numbers"]

for test in Tests:
  echo test
  var scores: seq[(float, string)]
  for task in tasks:
    scores.add (sorensenDice(test, task), task)
  scores.sort(Descending)
  for i in 0..4:
    echo "  ", scores[i][0].formatFloat(ffDecimal, 6), ' ', scores[i][1]
  echo()
