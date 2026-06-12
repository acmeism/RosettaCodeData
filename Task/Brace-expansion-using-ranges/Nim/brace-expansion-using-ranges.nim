import options, strutils, unicode


func intFromString(s: string): Option[int] =
  ## Try to parse an int. Return some(int) if parsing
  ## was successful, return none(int) if it failed.
  try:
    let n = s.parseInt()
    result = some(n)
  except ValueError:
    result = none(int)


func parseRange(r: string): seq[string] =

  if r.len == 0: return @["{}"]   # rangeless, empty.
  let sp = r.split("..")
  if sp.len == 1: return @['{' & r & '}']
  let first = sp[0]
  let last = sp[1]
  let incr = if sp.len == 2: "1" else: sp[2]

  let val1 = intFromString(first)
  let val2 = intFromString(last)
  let val3 = intFromString(incr)

  if val3.isNone(): return @['{' & r & '}']   # increment isn't a number.
  var n3 = val3.get()
  let numeric = val1.isSome and val2.isSome

  var n1, n2: int
  if numeric:
    n1 = val1.get()
    n2 = val2.get()
  else:
    if val1.isSome and val2.isNone or val1.isNone and val2.isSome:
      return @['{' & r & '}']   # mixed numeric/alpha not expanded.
    if first.runeLen != 1 or last.runeLen != 1:
      return @['{' & r & '}']   # start/end are not both single alpha.
    n1 = first.toRunes[0].int
    n2 = last.toRunes[0].int

  var width = 1
  if numeric:
    width = if first.len < last.len: last.len else: first.len

  if n3 == 0:
    # Zero increment.
    return if numeric: @[n1.intToStr(width)] else: @[first]

  var asc = n1 < n2
  if n3 < 0:
    asc = not asc
    swap n1, n2
    n3 = -n3

  var i = n1
  if asc:
    while i <= n2:
      result.add if numeric: i.intToStr(width) else: $Rune(i)
      inc i, n3
  else:
    while i >= n2:
      result.add if numeric: i.intToStr(width) else: $Rune(i)
      dec i, n3


func rangeExpand(s: string): seq[string] =

  result = @[""]
  var rng = ""
  var inRng = false

  for c in s:
    if c == '{' and not inRng:
      inRng = true
      rng = ""
    elif c == '}' and inRng:
      let rngRes = rng.parseRange()
      var res: seq[string]
      for i in 0..result.high:
        for j in 0..rngRes.high:
          res.add result[i] & rngRes[j]
      result = move(res)
      inRng = false
    elif inRng:
      rng.add c
    else:
      for s in result.mitems: s.add c

  if inRng:
    for s in result.mitems: s.add '{' & rng   # unmatched braces.


when isMainModule:

  const Examples = ["simpleNumberRising{1..3}.txt",
                    "simpleAlphaDescending-{Z..X}.txt",
                    "steppedDownAndPadded-{10..00..5}.txt",
                    "minusSignFlipsSequence {030..20..-5}.txt",
                    "combined-{Q..P}{2..1}.txt",
                    "emoji{🌵..🌶}{🌽..🌾}etc",
                    "li{teral",
                    "rangeless{}empty",
                    "rangeless{random}string",
                    "mixedNumberAlpha{5..k}",
                    "steppedAlphaRising{P..Z..2}.txt",
                    "stops after endpoint-{02..10..3}.txt"]

  for s in Examples:
    stdout.write s, " →\n    "
    let res = rangeExpand(s)
    stdout.write res.join("\n    ")
    echo '\n'
