import sequtils, strformat, strutils

func lcp(list: varargs[string]): string =
  if list.len == 0: return
  result = list[0]
  for i in 1..list.high:
    var newLength = 0
    for j in 0..result.high:
      if j >= list[i].len or list[i][j] != result[j]:
        break
      inc newLength
    result.setLen(newLength)

proc test(list: varargs[string]) =
  let lst = list.mapIt('"' & it & '"').join(", ")
  echo &"lcp({lst}) = \"{lcp(list)}\""


test("interspecies", "interstellar", "interstate")
test("throne", "throne")
test("throne", "dungeon")
test("cheese")
test("")
test()
test("prefix", "suffix")
test("foo", "foobar")
