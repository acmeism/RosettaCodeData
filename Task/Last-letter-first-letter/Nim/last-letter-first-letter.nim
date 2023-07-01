import tables

const Names = ["audino", "bagon", "baltoy", "banette", "bidoof", "braviary", "bronzor",
               "carracosta", "charmeleon", "cresselia", "croagunk", "darmanitan", "deino",
               "emboar", "emolga", "exeggcute", "gabite", "girafarig", "gulpin", "haxorus",
               "heatmor", "heatran", "ivysaur", "jellicent", "jumpluff", "kangaskhan",
               "kricketune", "landorus", "ledyba", "loudred", "lumineon", "lunatone",
               "machamp", "magnezone", "mamoswine", "nosepass", "petilil", "pidgeotto",
               "pikachu", "pinsir", "poliwrath", "poochyena", "porygon2", "porygonz",
               "registeel", "relicanth", "remoraid", "rufflet", "sableye", "scolipede",
               "scrafty", "seaking", "sealeo", "silcoon", "simisear", "snivy", "snorlax",
               "spoink", "starly", "tirtouga", "trapinch", "treecko", "tyrogue", "vigoroth",
               "vulpix", "wailord", "wartortle", "whismur", "wingull", "yamask"]

type
  Index = range[0..Names.len-1]
  IndexSet = set[Index]
  Successors = Table[Index, IndexSet]

const All = {Index.low..Index.high}   # All indexes.


func initSuccessors(): Successors {.compileTime.} =
  ## Build the mapping from name indexes to set of possible successor indexes.

  var names: Table[char, IndexSet]  # Map first char to IndexSet.
  for idx, name in Names:
    names.mgetOrPut(name[0], {}).incl(idx)
  for idx, name in Names:
    result[idx] = names.getOrDefault(name[^1]) - {idx}

# Mapping name index -> set of successor indexes.
const Succ = initSuccessors()


proc search(starts, available: IndexSet): seq[Index] =
  ## Search one of the longest sequence of indexes for given
  ## starting indexes and given available name indexes.
  var maxLen = -1
  for idx in starts * available:
    let list = search(Succ[idx], available - {idx})
    if list.len > maxLen:
      result = idx & list
      maxLen = list.len


let list = search(starts = All, available = All)
echo "Longest lists have length: ", list.len
echo "One of these lists is:"
for idx in list: echo Names[idx]
