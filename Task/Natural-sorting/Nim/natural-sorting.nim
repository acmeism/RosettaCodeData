import algorithm, parseutils, pegs, strutils, unidecode

type

  Kind = enum fString, fNumber

  KeyItem= object
    case kind: Kind
    of fString: str: string
    of fNumber: num: Natural

  Key = seq[KeyItem]


func cmp(a, b: Key): int =
  ## Compare two keys.

  for i in 0..<min(a.len, b.len):
    let ai = a[i]
    let bi = b[i]
    if ai.kind == bi.kind:
      result = if ai.kind == fString: cmp(ai.str, bi.str) else: cmp(ai.num, bi.num)
      if result != 0: return
    else:
      return if ai.kind == fString: 1 else: -1
  result = if a.len < b.len: -1 else: (if a.len == b.len: 0 else: 1)


proc natOrderKey(s: string): Key =
  ## Return the natural order key for a string.

  # Process 'ʒ' separately as "unidecode" converts it to 'z'.
  var s = s.replace("ʒ", "s")

  # Transform UTF-8 text into ASCII text.
  s = s.unidecode()

  # Remove leading and trailing white spaces.
  s = s.strip()

  # Make all whitespace characters equivalent and remove adjacent spaces.
  s = s.replace(peg"\s+", " ")

  # Switch to lower case.
  s = s.toLowerAscii()

  # Remove leading "the ".
  if s.startsWith("the ") and s.len > 4: s = s[4..^1]

  # Split into fields.
  var idx = 0
  var val: int
  while idx < s.len:
    var n = s.skipUntil(Digits, start = idx)
    if n != 0:
      result.add KeyItem(kind: fString, str: s[idx..<(idx + n)])
      inc idx, n
    n = s.parseInt(val, start = idx)
    if n != 0:
      result.add KeyItem(kind: fNumber, num: val)
      inc idx, n


proc naturalCmp(a, b: string): int =
  ## Natural order comparison function.
  cmp(a.natOrderKey, b.natOrderKey)


when isMainModule:

  proc test(title: string; list: openArray[string]) =
    echo title
    echo sorted(list, naturalCmp)
    echo ""

  test("Ignoring leading spaces.",
       ["ignore leading spaces:  2-2",
        "ignore leading spaces:  2-1",
        "ignore leading spaces:  2+0",
        "ignore leading spaces:  2+1"])

  test("Ignoring multiple adjacent spaces (MAS).",
       ["ignore MAS spaces:  2-2",
        "ignore MAS spaces:  2-1",
        "ignore MAS spaces:  2+0",
        "ignore MAS spaces:  2+1"])

  test("Equivalent whitespace characters.",
       ["Equiv.  spaces:     3-3",
        "Equiv. \rspaces:    3-2",
        "Equiv. \x0cspaces:  3-1",
        "Equiv. \x0bspaces:  3+0",
        "Equiv. \nspaces:    3+1",
        "Equiv. \tspaces:    3+2"])

  test("Case Independent sort.",
       ["cASE INDEPENDENT:  3-2",
        "caSE INDEPENDENT:  3-1",
        "casE INDEPENDENT:  3+0",
        "case INDEPENDENT:  3+1"])

  test("Numeric fields as numerics.",
       ["foo100bar99baz0.txt",
        "foo100bar10baz0.txt",
        "foo1000bar99baz10.txt",
        "foo1000bar99baz9.txt"])

  test("Title sorts.",
       ["The Wind in the Willows",
        "The 40th step more",
        "The 39 steps",
        "Wanda"])

  test("Equivalent accented characters (and case).",
       ["Equiv. ý accents:  2-2",
        "Equiv. Ý accents:  2-1",
        "Equiv. y accents:  2+0",
        "Equiv. Y accents:  2+1"])

  test("Separated ligatures.",
       ["Ĳ ligatured ij",
        "no ligature"])

  test("Character replacements.",
       ["Start with an ʒ:  2-2",
        "Start with an ſ:  2-1",
        "Start with an ß:  2+0",
        "Start with an s:  2+1"])
