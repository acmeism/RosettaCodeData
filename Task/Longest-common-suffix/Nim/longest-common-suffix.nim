import sequtils, strformat, strutils

func lcs(list: varargs[string]): string =
  if list.len == 0: return
  result = list[0]
  for i in 1..list.high:
    var newLength = 0
    for j in 1..result.len:
      if j > list[i].len or list[i][^j] != result[^j]:
        break
      inc newLength
    result = result[^newLength..^1]

proc test(list: varargs[string]) =
  let lst = list.mapIt('"' & it & '"').join(", ")
  echo &"lcs({lst}) = \"{lcs(list)}\""


test("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
test("throne", "throne")
test("throne", "dungeon")
test("cheese")
test("")
test()
test("prefix", "suffix")
test("send", "lend")
