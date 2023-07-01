import sequtils, strutils, sets, tables, sugar

type StringSet = HashSet[string]


proc topSort(data: var OrderedTable[string, StringSet]) =
  ## Topologically sort the data in place.

  var ranks: Table[string, Natural]   # Maps the keys to a rank.

  # Remove self dependencies.
  for key, values in data.mpairs:
    values.excl key

  # Add extra items (i.e items present in values but not in keys).
  for values in toSeq(data.values):
    for value in values:
      if value notin data:
        data[value] = initHashSet[string]()

  # Find ranks.
  var deps = data   # Working copy of the table.
  var rank = 0
  while deps.len > 0:

    # Find a key with an empty dependency set.
    var keyToRemove: string
    for key, values in deps.pairs:
      if values.card == 0:
        keyToRemove = key
        break
    if keyToRemove.len == 0:
      # Not found: there is a cycle.
      raise newException(ValueError, "Unorderable items found: " & toSeq(deps.keys).join(", "))

    # Assign a rank to the key and remove it from keys and values.
    ranks[keyToRemove] = rank
    inc rank
    deps.del keyToRemove
    for k, v in deps.mpairs:
      v.excl keyToRemove

  # Sort the original data according to the ranks.
  data.sort((x, y) => cmp(ranks[x[0]], ranks[y[0]]))


when isMainModule:

  const Data = {"des_system_lib": ["std", "synopsys", "std_cell_lib",
                                   "des_system_lib", "dw02", "dw01",
                                   "ramlib", "ieee"].toHashSet,
                "dw01": ["ieee", "dw01", "dware", "gtech"].toHashSet,
                "dw02": ["ieee", "dw02", "dware"].toHashSet,
                "dw03": ["std", "synopsys", "dware", "dw03",
                         "dw02", "dw01", "ieee", "gtech"].toHashSet,
                "dw04": ["dw04", "ieee", "dw01", "dware", "gtech"].toHashSet,
                "dw05": ["dw05", "ieee", "dware"].toHashSet,
                "dw06": ["dw06", "ieee", "dware"].toHashSet,
                "dw07": ["ieee", "dware"].toHashSet,
                "dware": ["ieee", "dware"].toHashSet,
                "gtech": ["ieee", "gtech"].toHashSet,
                "ramlib": ["std", "ieee"].toHashSet,
                "std_cell_lib": ["ieee", "std_cell_lib"].toHashSet,
                "synopsys": initHashSet[string]()}.toOrderedTable

  # Process the original data (without cycle).
  echo "Data without cycle. Order after sorting:"
  var data = Data
  try:
    data.topSort()
    for key in data.keys: echo key
  except ValueError:
    echo getCurrentExceptionMsg()

  # Process the modified data (with a cycle).
  echo "\nData with a cycle:"
  data = Data
  data["dw01"].incl "dw04"
  try:
    data.topSort()
    for key in data.keys: echo key
  except ValueError:
    echo getCurrentExceptionMsg()
