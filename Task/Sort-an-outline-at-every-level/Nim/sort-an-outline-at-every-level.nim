import algorithm, sequtils, strformat, strutils

type

  OutlineEntry = ref object
    level: Natural
    text: string
    parent: OutlineEntry
    children: seq[OutlineEntry]

  Outline = object
    root: OutlineEntry
    baseIndent: string


proc splitLine(line: string): (string, string) =
  for i, ch in line:
    if ch notin {' ', '\t'}:
      return (line[0..<i], line[i..^1])
  result = (line, "")


proc firstIndent(lines: seq[string]; default = "        "): string =
  for line in lines:
    result = line.splitLine()[0]
    if result.len != 0: return
  result = default


proc parent(arr: seq[OutlineEntry]; parentLevel: Natural): int =
  for i in countdown(arr.high, 0):
    if arr[i].level == parentLevel:
      return i


proc initOutline(str: string): Outline =

  let root = OutlineEntry()
  var arr = @[root]   # Outline entry at level 0 is root.
  let lines = str.splitLines().filterIt(it.len != 0)
  let indent = lines.firstIndent()
  var parentIndex = 0
  var lastIndents = 0

  if ' ' in indent and '\t' in indent:
    raise newException(ValueError, "Mixed tabs and spaces in indent are not allowed")

  let indentLen = indent.len

  for i, line in lines:
    let (header, txt) = line.splitLine()
    let indentCount = header.count(indent)
    if indentCount * indentLen != header.len:
      raise newException(
              ValueError, &"Error: bad indent 0x{header.toHex}, expected 0x{indent.toHex}")
    if indentCount > lastIndents:
      parentIndex = i
    elif indentCount < lastIndents:
      parentIndex = arr.parent(indentCount)
    lastIndents = indentCount
    let entry = OutlineEntry(level: indentCount + 1, text: txt, parent: arr[parentIndex])
    entry.parent.children.add entry
    arr.add entry

  result = Outline(root: root, baseIndent: indent)


proc sort(entry: OutlineEntry; order = Ascending; level = 0) =
  ## Sort an outline entry in place.
  for child in entry.children.mitems:
    child.sort(order)
  if level == 0 or level == entry.level:
    entry.children.sort(proc(x, y: OutlineEntry): int = cmp(x.text, y.text), order)


proc sort(outline: var Outline; order = Ascending; level = 0) =
  ## Sort an outline.
  outline.root.sort(order, level)


proc `$`(outline: Outline): string =
  ## Return the string representation of an outline.

  proc `$`(entry: OutlineEntry): string =
    ## Return the string representation of an outline entry.
    result = repeat(outline.baseIndent, entry.level) & entry.text & '\n'
    for child in entry.children:
      result.add $child

  result = $outline.root


var outline4s = initOutline("""
zeta
    beta
    gamma
        lambda
        kappa
        mu
    delta
alpha
    theta
    iota
    epsilon""")

var outlinet1 = initOutline("""
zeta
    gamma
        mu
        lambda
        kappa
    delta
    beta
alpha
    theta
    iota
    epsilon""")

echo "Given the text:\n", outline4s
outline4s.sort()
echo "Sorted outline is:\n", outline4s
outline4s.sort(Descending)
echo "Reverse sorted is:\n", outline4s

echo "Using the text:\n", outlinet1
outlinet1.sort()
echo "Sorted outline is:\n", outlinet1
outlinet1.sort(Descending)
echo "Reverse sorted is:\n", outlinet1
outlinet1.sort(level = 3)
echo "Sorting only third level:\n", outlinet1

try:
  echo "Trying to parse a bad outline:"
  var outlinebad1 = initOutline("""
alpha
    epsilon
	iota
    theta
zeta
    beta
    delta
    gamma
    	kappa
        lambda
        mu""")
except ValueError:
  echo getCurrentExceptionMsg()

try:
  echo "Trying to parse another bad outline:"
  var outlinebad2 = initOutline("""
zeta
    beta
   gamma
        lambda
         kappa
        mu
    delta
alpha
    theta
    iota
    epsilon""")
except ValueError:
  echo getCurrentExceptionMsg()
