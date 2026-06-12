import strutils

const
  FStrs = [("MAC", "MCC"), ("KN", "N"), ("K", "C"),
           ("PH", "FF"), ("PF", "FF"), ("SCH", "SSS")]
  LStrs = [("EE", "Y"), ("IE", "Y"), ("DT", "D"),
           ("RT", "D"), ("RD", "D"), ("NT", "D"), ("ND", "D")]
  MStrs = [("EV", "AF"), ("KN", "N"), ("SCH", "SSS"), ("PH", "FF")]
  EStrs = ["JR", "JNR", "SR", "SNR"]


func isVowel(c: char): bool = c in {'A', 'E', 'I', 'O', 'U'}

func isRoman(s: string): bool = s.allCharsInSet({'I', 'V', 'X'})


func nysiis(word: string): string =

  if word.len == 0: return
  var word  = word.toUpperAscii()
  let fields = word.split({' ', ','})
  if fields.len > 1:
    let last = fields[^1]
    if last.isRoman: word.setLen(word.len - last.len)
  word = word.multiReplace((" ", ""), (",", ""), ("'", ""), ("-", ""))
  for eStr in EStrs:
    if word.endsWith(eStr): word.setLen(word.len - eStr.len)
  for fStr in FStrs:
    if word.startsWith(fStr[0]): word[0..fStr[0].high] = fStr[1]
  for lStr in LStrs:
    if word.endsWith(lStr[0]): word[^2..^1] = lStr[1]

  result.add word[0]
  word.delete(0..0)
  for mStr in MStrs:
    word = word.replace(mStr[0], mStr[1])
  var s = result[0] & word
  var len = s.len
  for i in 1..<len:
    case s[i]
    of 'E', 'I', 'O', 'U': s[i] = 'A'
    of 'Q': s[i] = 'G'
    of 'Z': s[i] = 'S'
    of 'M': s[i] = 'N'
    of 'K': s[i] = 'C'
    of 'H': (if not s[i-1].isVowel or i < len - 1 and not s[i+1].isVowel: s[i] = s[i-1])
    of 'W': (if s[i-1].isVowel: s[i] = 'A')
    else: discard

  if s[len-1] == 'S':
    s.setLen(len-1)
    dec len
  if len > 1 and s[len-2..len-1] == "AY":
    s.delete(len-2..len-2)
    dec len
  if len > 0 and s[len-1] == 'A':
    s.setLen(len-1)
    dec len
  if len > 0 and s[len-1] == 'A':
    s.setLen(len-1)
    dec len

  var prev = result[0]
  for i in 1..<len:
    let c = s[i]
    if prev != c:
      result.add c
      prev = c


const Names = ["Bishop", "Carlson", "Carr", "Chapman",
               "Franklin", "Greene", "Harper", "Jacobs", "Larson", "Lawrence",
               "Lawson", "Louis, XVI", "Lynch", "Mackenzie", "Matthews", "May jnr",
               "McCormack", "McDaniel", "McDonald", "Mclaughlin", "Morrison",
               "O'Banion", "O'Brien", "Richards", "Silva", "Watkins", "Xi",
               "Wheeler", "Willis", "brown, sr", "browne, III", "browne, IV",
               "knight", "mitchell", "o'daniel", "bevan", "evans", "D'Souza",
               "Hoyle-Johnson", "Vaughan Williams", "de Sousa", "de la Mare II"]

for name1 in Names:
  var name2 = nysiis(name1)
  if name2.len > 6:
    name2 = "$1($2)".format(name2[0..5], name2[6..^1])
  echo name1.alignLeft(16), ": ", name2
