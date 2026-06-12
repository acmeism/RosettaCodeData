import std/[algorithm, sequtils, strformat, strutils, tables]

const

  Numbers = {"fourteen": "14", "sixteen": "16",  "seventeen": "17", "eighteen": "18",
             "nineteen": "19", "sixty": "60",    "seventy": "70",   "eighty": "80",
             "ninety": "90",   "one": "1",       "two": "2",        "three": "3",
             "four": "4",      "five": "5",      "six": "6",        "seven": "7",
             "eight": "8",     "nine": "9",      "ten": "10",       "eleven": "11",
             "twelve": "12",   "thirteen": "13", "fifteen": "15",   "twenty": "20",
             "thirty": "30",   "forty": "40",    "fifty": "50",     "single": "1"}.toOrderedTable

  Punctuation = {"comma": ",", "hyphen": "-", "apostrophe": "'", "exclamation": "!"}.toTable

  LowerLetters = {'a'..'z'}
  Symbols = {',', '-', '\'', '!'}

proc autogram(sentence: string; ignorePunct: bool) =
  echo &"Sentence:\n{sentence}"
  echo &"""Ignore punctuation: {["no", "yes"][ord(ignorePunct)]}"""
  var s = sentence.toLowerAscii
  # Get actual character counts.
  let chars = if ignorePunct: LowerLetters else: LowerLetters + Symbols
  var ctable1: CountTable[char]
  for c in s:
    if c in chars:
      ctable1.inc(c)
  let keys1 = sorted(ctable1.keys.toSeq)   # Sort into lexicographical order.
  let charCounts1 = keys1.mapIt((it, ctable1[it])).join(" ")
  echo "\nActual character counts:"
  echo charCounts1

  for text, value in Numbers.pairs:
    s = s.replace(text, value)
  if not ignorePunct:
    for punct in Punctuation.pairs:
      s = s.replace(punct[0], punct[1])
  let words = s.split(' ')
  var ctable2: CountTable[char]
  let wc = words.len
  var i = 0
  while i < wc - 1:
    if words[i].all(isDigit):
      if words[i+1].all(isDigit) and i + 2 < wc:
        let count = words[i].parseInt() + words[i+1].parseInt()
        let ch = words[i + 2][0]
        ctable2[ch] = count
        inc i, 3
      else:
        let count = words[i].parseInt()
        let ch = words[i + 1][0]
        ctable2[ch] = count
        inc i, 2
    elif '-' in words[i]:
      let split = words[i].split('-')
      if split[0].all(isDigit) and split[1].all(isDigit):
        let count = split[0].parseInt() + split[1].parseInt()
        let ch = words[i + 1][0]
        ctable2[ch] = count
        inc i, 2
      else:
        inc i
    else:
      inc i

  let keys2 = sorted(ctable2.keys.toSeq)
  let charCounts2 = keys2.mapIt((it, ctable2[it])).join(" ")
  echo "\nPurported character counts:"
  echo charCounts2
  echo &"\nIs autogram? {charCounts1 == charCounts2}"

const Tests = [
    ("This sentence employs two a's, two c's, two d's, twenty-eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty-five s's, twenty-three t's, six v's, ten w's, two x's, five y's, and one z.", true),
    ("This sentence employs two a's, two c's, two d's, twenty eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's, ten w's, two x's, five y's, and one z.", true),
    ("Only the fool would take trouble to verify that his sentence was composed of ten a's, three b's, four c's, four d's, forty-six e's, sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's, four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's, forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's, eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens and, last but not least, a single !", false),
    ("This pangram contains four as, one b, two cs, one d, thirty es, six fs, five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns, fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us, seven vs, eight ws, two xs, three ys, & one z.", true),
    ("This sentence contains one hundred and ninety-seven letters: four a's, one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's, twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's, nineteen t's, six u's, seven v's, four w's, four x's, five y's, and one z.", true),
    ("Thirteen e's, five f's, two g's, five h's, eight i's, two l's, three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's, six w's, four x's, two y's.", true),
    ("Fifteen e's, seven f's, four g's, six h's, eight i's, four n's, five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's, three x's.", false),
    ("Sixteen e's, five f's, three g's, six h's, nine i's, five n's, four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's, four z's.", true)
    ]

for t in Tests:
  autogram(t[0], t[1])
  echo repeat('=', 80)
