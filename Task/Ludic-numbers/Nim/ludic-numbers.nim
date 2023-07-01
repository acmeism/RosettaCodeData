import strutils

type LudicArray[N: static int] = array[1..N, int]

func initLudicArray[N: static int](): LudicArray[N] =
  ## Initialize an array of ludic numbers.
  result[1] = 1
  for i in 2..N:
    var k = 0
    for j in countdown(i - 1, 2):
      k = k * result[j] div (result[j] - 1) + 1
    result[i] = k + 2


proc print(text: string; list: openArray[int]) =
  ## Print a text followed by a list of ludic numbers.
  var line = text
  let start = line.len
  for val in list:
    line.addSep(", ", start)
    line.add $val
  echo line


func isLudic(ludicArray: LudicArray; n, start: Positive): bool =
  ## Check if a number "n" is ludic, starting search from index "start".
  for idx in start..ludicArray.N:
    let val = ludicArray[idx]
    if n == val: return true
    if n < val: break


when isMainModule:

  let ludicArray = initLudicArray[2005]()

  print "The 25 first ludic numbers are: ", ludicArray[1..25]

  var count = 0
  for n in ludicArray:
    if n > 1000: break
    inc count
  echo "\nThere are ", count, " ludic numbers less or equal to 1000."

  print "\nThe 2000th to 2005th ludic numbers are: ", ludicArray[2000..2005]

  echo "\nThe triplets of ludic numbers less than 250 are:"
  var line = ""
  for i, n in ludicArray:
    if n >= 244:
      echo line
      break
    if ludicArray.isLudic(n + 2, i + 1) and ludicArray.isLudic(n + 6, i + 2):
      line.addSep(", ")
      line.add "($1, $2, $3)".format(n, n + 2, n + 6)
