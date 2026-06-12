import strutils

const
  Vowels = {'a', 'e', 'i', 'o', 'u'}
  Consonants = {'a'..'z'} - Vowels

func value(val: int; unit: string): string =
  $val & ' ' & unit & (if val > 1: "s" else: "")

proc vcCount(text: string) =
  var vowels, consonants: set[char]
  var vowelCount, consonantCount = 0
  for c in text.toLowerAscii:
    if c in Consonants:
      consonants.incl c
      inc consonantCount
    elif c in Vowels:
      vowels.incl c
      inc vowelCount
  echo "“$#” contains" % text
  echo "    $1 and $2 (distinct)".format(value(vowels.card, "vowel"),
                                         value(consonants.card, "consonant"))
  echo "    $1 and $2 (total)".format(value(vowelCount, "vowel"),
                                      value(consonantCount, "consonant"))

vcCount("Now is the time for all good men to come to the aid of their country.")
