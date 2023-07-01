import unicode, strformat

proc collapse(s: string) =
  let original = s.toRunes
  echo fmt"Original:  length = {original.len}, string = «««{s}»»»"
  var previous = Rune(0)
  var collapsed: seq[Rune]
  for rune in original:
    if rune != previous:
      collapsed.add(rune)
      previous = rune
  echo fmt"Collapsed: length = {collapsed.len}, string = «««{collapsed}»»»"
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


for s in Strings:
  s.collapse()
