import rdstdin

proc isPangram(sentence: string, alphabet = {'a'..'z'}): bool =
  var sentset: set[char] = {}
  for c in sentence: sentset.incl c
  alphabet <= sentset

echo isPangram(readLineFromStdin "Sentence: ")
