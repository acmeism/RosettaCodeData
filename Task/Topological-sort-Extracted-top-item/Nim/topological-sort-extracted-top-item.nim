import algorithm, sequtils, strutils, sets, tables

type
  StringSet = HashSet[string]
  StringSeq = seq[string]

const Empty: StringSet = initHashSet[string]()


func topLevels(data: Table[string, StringSet]): StringSet =
  ## Extract all top levels from dependency data.

  # Remove self dependencies.
  var data = data
  for key, values in data.mpairs:
    values.excl key

  let deps = toSeq(data.values).foldl(a + b)
  result = toSeq(data.keys).toHashSet - deps


func topx(data: Table[string, StringSet]; tops: StringSet;
          sofar: var seq[StringSet]): seq[StringSeq] =
  ## Recursive topological extractor.
  sofar = sofar & tops
  var depends: StringSet
  for top in tops:
    depends = depends + data.getOrDefault(top, Empty)
  if depends.card != 0: discard data.topx(depends, sofar)
  var accum = Empty
  for i in countdown(sofar.high, 0):
    result.add sorted(toSeq(sofar[i] - accum))
    accum = accum + sofar[i]


func topx(data: Table[string, StringSet]; tops = initHashSet[string]()): seq[StringSeq] =
  ## Extract the set of top-level(s) in topological order.

  # Remove self dependencies.
  var data = data
  for key, values in data.mpairs:
    values.excl key

  var tops = tops
  if tops.card == 0: tops = data.topLevels

  var sofar: seq[StringSet]
  result = data.topx(tops, sofar)


proc printOrder(order: seq[StringSeq]) =
  ## Prettyprint topological ordering.
  if order.len != 0:
    echo "First: ", order[0].join(", ")
  for i in 1..order.high:
    echo " Then: ", order[i].join(", ")


when isMainModule:

  const Data = {"top1":  ["ip1", "des1", "ip2"].toHashSet,
                "top2":  ["ip2", "des1", "ip3"].toHashSet,
                "des1":  ["des1a", "des1b", "des1c"].toHashSet,
                "des1a": ["des1a1", "des1a2"].toHashSet,
                "des1c": ["des1c1", "extra1"].toHashSet,
                "ip2":   ["ip2a", "ip2b", "ip2c", "ipcommon"].toHashSet,
                "ip1":   ["ip1a", "ipcommon", "extra1"].toHashSet}.toTable

  let tops = Data.topLevels()
  let topList = sorted(tops.toSeq)
  echo "The top levels of the dependency graph are: ", topList.join(", ")
  for t in topList:
    echo "\nThe compile order for top level “$#” is..." % t
    printOrder Data.topx([t].toHashSet)

  if tops.len > 1:
    echo "\nThe compile order for top levels $# is..." % topList.mapIt("“" & it & "”").join(" and ")
    printOrder Data.topx(tops)
