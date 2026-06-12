import options, sequtils, strutils

type Position = tuple[ff, lf, tab, sp: int]

func buildUserInput(s: string): seq[Position] =
  let valList = s.splitWhitespace().map(parseInt)
  doAssert valList.len mod 4 == 0, "Number of values must be a multiple of four."
  doAssert valList.allIt(it >= 0), "Expected non negative values."
  let posList = valList.distribute(valList.len div 4)
  result = posList.mapIt((ff: it[0], lf: it[1], tab: it[2], sp: it[3]))


proc decode(filename: string; uiList: seq[Position]): string =

  func decode(text: string; ui: Position): Option[char] =
    var f, l, t, s = 0
    let (ff, lf, tab, sp) = ui
    for c in text:
      if f == ff and l == lf and t == tab and s == sp:
        return if c == '!': none(char) else: some(c)
      case c
      of '\f': inc f; l = 0; t = 0; s = 0
      of '\l': inc l; t = 0; s = 0
      of '\t': inc t; s = 0
      else: inc s

  let text = filename.readFile()
  for ui in uiList:
    let c = text.decode(ui)
    if c.isNone: break
    result.add c.get()

const UiList = buildUserInput("0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 " &
                              "45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 " &
                              "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 " &
                              "33 0 50 0 46 0 54 0 76 0 47 0 84 2 28")

echo "theRaven.txt".decode(UiList)
