import tables, options

type
  MyTable = object
    table: TableRef[string, int]

# return empty if the key is not available
proc `[]`(m: MyTable, key: string): Option[int] =
  if key in m.table: result = some m.table[key]
  else: result = none int

# update an item, doing nothing if the key is available during first initialization
proc `[]=`(m: var MyTable, key: string, val: int) =
  if key notin m.table: return
  m.table[key] = val

proc reset(m: var MyTable) =
  for _, v in m.table.mpairs: v = 0

# sugar for defining MyTable object
proc toTable(vals: openarray[(string, int)]): MyTable =
  result.table = newTable vals

proc main =
  # MyTable construction
  var myobj = {"key1": 1, "key2": 2, "key3": 3}.toTable
  # test getting existing key
  let val1 = myobj["key1"]
  if val1.isSome: echo "val1: ", val1.get

  # test adding new key
  myobj["key4"] = 4
  let val4 = myobj["key4"]
  if val4.isSome: echo val4.get
  else: echo "val4 is empty"

  # test reset and test whether its value is zero-ed
  reset myobj
  doAssert myobj["key3"].get == 0

main()
