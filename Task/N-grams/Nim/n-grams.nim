import std/[strutils, tables]

type NGrams = CountTable[string]

func ngrams(text: string; n: Positive): NGrams =
  for i in 0..(text.len - n):
    result.inc(text[i..<(i + n)].toLowerAscii)

const Text = "Live and let live"

for n in 2..4:
  echo n, "-grams:"
  var ng = Text.ngrams(n)
  ng.sort()               # To display n-grams with higher score first.
  for key, count in ng:
    echo "“$1”: $2".format(key, count)
  echo()
