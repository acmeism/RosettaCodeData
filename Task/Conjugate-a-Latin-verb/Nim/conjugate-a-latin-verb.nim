import std/[strformat, unicode]

const
  Endings = [["o", "as", "at", "amus", "atis", "ant"],
             ["eo", "es", "et", "emus", "etis", "ent"],
             ["o", "is", "it", "imus", "itis", "unt"],
             ["io", "is", "it", "imus", "itis", "iunt"]]
  InfinEndings = ["are", "ēre", "ere", "ire"]
  Pronouns = ["I", "you (singular)", "he, she or it", "we", "you (plural)", "they"]
  EnglishEndings = ["", "", "s", "", "", ""]


proc conjugate(infinitive, english: string) =
  let letters = infinitive.toRunes()
  if letters.len < 4:
    raise newException(ValueError, "infinitive is too short for a regular verb.")
  let infinEnding = $letters[^3..^1]
  let conj = InfinEndings.find(infinEnding)
  if conj == -1:
    raise newException(ValueError, &"infinitive ending -{infinEnding} not recognized.")
  let stem = $letters[0..^4]
  echo &"Present indicative tense, active voice, of '{infinitive}' to '{english}':"
  for i, ending in Endings[conj]:
    echo &"    {stem}{ending:4}  {Pronouns[i]} {english}{EnglishEndings[i]}"
  echo()


for (infinitive, english) in {"amare": "love", "vidēre": "see", "ducere": "lead", "audire": "hear"}:
  conjugate(infinitive, english)
