import unicode, strformat

proc squeeze(s: string; ch: Rune) =
  echo fmt"Specified character: '{ch}'"
  let original = s.toRunes
  echo fmt"Original: length = {original.len}, string = «««{s}»»»"
  var previous = Rune(0)
  var squeezed: seq[Rune]
  for rune in original:
    if rune != previous:
      squeezed.add(rune)
      previous = rune
    elif rune != ch:
      squeezed.add(rune)
  echo fmt"Squeezed: length = {squeezed.len}, string = «««{squeezed}»»»"
  echo ""


const Strings = ["",
        "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ",
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                   ---  Harry S Truman  ",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship",
        "aardvark",
        "😍😀🙌💃😍😍😍🙌",]

const Chars = [@[Rune(' ')], @[Rune('-')], @[Rune('7')], @[Rune('.')],
               @[Rune(' '), Rune('-'), Rune('r')],
               @[Rune('e')], @[Rune('s')], @[Rune('a')], "😍".toRunes]


for i, s in Strings:
  for ch in Chars[i]:
    s.squeeze(ch)
