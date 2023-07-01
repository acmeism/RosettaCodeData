import sequtils, random, strutils

const
  Pairs = 10
  MNames = ["abe", "bob", "col", "dan", "ed", "fred", "gav", "hal", "ian", "jon"]
  FNames = ["abi", "bea", "cath", "dee", "eve", "fay", "gay", "hope", "ivy", "jan"]
  MPreferences = [
    ["abi", "eve", "cath", "ivy", "jan", "dee", "fay", "bea", "hope", "gay"],
    ["cath", "hope", "abi", "dee", "eve", "fay", "bea", "jan", "ivy", "gay"],
    ["hope", "eve", "abi", "dee", "bea", "fay", "ivy", "gay", "cath", "jan"],
    ["ivy", "fay", "dee", "gay", "hope", "eve", "jan", "bea", "cath", "abi"],
    ["jan", "dee", "bea", "cath", "fay", "eve", "abi", "ivy", "hope", "gay"],
    ["bea", "abi", "dee", "gay", "eve", "ivy", "cath", "jan", "hope", "fay"],
    ["gay", "eve", "ivy", "bea", "cath", "abi", "dee", "hope", "jan", "fay"],
    ["abi", "eve", "hope", "fay", "ivy", "cath", "jan", "bea", "gay", "dee"],
    ["hope", "cath", "dee", "gay", "bea", "abi", "fay", "ivy", "jan", "eve"],
    ["abi", "fay", "jan", "gay", "eve", "bea", "dee", "cath", "ivy", "hope"]
  ]
  FPreferences = [
    ["bob", "fred", "jon", "gav", "ian", "abe", "dan", "ed", "col", "hal"],
    ["bob", "abe", "col", "fred", "gav", "dan", "ian", "ed", "jon", "hal"],
    ["fred", "bob", "ed", "gav", "hal", "col", "ian", "abe", "dan", "jon"],
    ["fred", "jon", "col", "abe", "ian", "hal", "gav", "dan", "bob", "ed"],
    ["jon", "hal", "fred", "dan", "abe", "gav", "col", "ed", "ian", "bob"],
    ["bob", "abe", "ed", "ian", "jon", "dan", "fred", "gav", "col", "hal"],
    ["jon", "gav", "hal", "fred", "bob", "abe", "col", "ed", "dan", "ian"],
    ["gav", "jon", "bob", "abe", "ian", "dan", "hal", "ed", "col", "fred"],
    ["ian", "col", "hal", "gav", "fred", "bob", "abe", "ed", "jon", "dan"],
    ["ed", "hal", "gav", "abe", "bob", "jon", "col", "ian", "fred", "dan"]
  ]

# recipient's preferences hold the preference score for each contender's id
func getRecPreferences[N: static int](prefs: array[N, array[N, string]],
    names: openArray[string]): array[N, array[N, int]] {.compileTime.} =
  for r, prefArray in pairs(prefs):
    for c, contender in pairs(prefArray):
      result[r][c] = prefArray.find(MNames[c])

# contender's preferences hold the recipient ids in descending order of preference
func getContPreferences[N: static int](prefs: array[N, array[N, string]],
     names: openArray[string]): array[N, array[N, int]] {.compileTime.} =
  for c, pref_seq in pairs(prefs):
    for r, pref in pairs(pref_seq):
      result[c][r] = names.find(pref)

const
  RecipientPrefs = getRecPreferences(FPreferences, MNames)
  ContenderPrefs = getContPreferences(MPreferences, FNames)

proc printCoupleNames(contPairs: seq[int]) =
  for c, r in pairs(contPairs):
    echo MNames[c] & " 💑 " & FNames[contPairs[c]]

func pair(): (seq[int], seq[int]) =
  # double booking to avoid inverse lookup using find
  var
    recPairs = newSeqWith(10, -1)
    contPairs = newSeqWith(10, -1)
  template engage(c, r: int) =
    #echo FNames[r] & " accepted " & MNames[c]
    contPairs[c] = r
    recPairs[r] = c
  var contQueue = newSeqWith(10, 0)
  while contPairs.contains(-1):
    for c in 0..<Pairs:
      if contPairs[c] == -1:
        let r = ContenderPrefs[c][contQueue[c]] #proposing to first in queue
        contQueue[c] += 1 #increment contender's queue for following iterations
        let curPair = recPairs[r] # current pair's index or -1 = vacant
        if curPair == -1:
          engage(c, r)
        # contender is more preferable than current
        elif RecipientPrefs[r][c] < RecipientPrefs[r][curPair]:
          contPairs[curPair] = -1 # vacate current pair
          #echo MNames[curPair] & " was dumped by " & FNames[r]
          engage(c, r)
  result = (contPairs, recPairs)

proc randomPair(max: int): (int, int) =
  let a = rand(max)
  var b = rand(max - 1)
  if b == a:
    b = max
  result = (a, b)

proc perturbPairs(contPairs, recPairs: var seq[int]) =
  randomize()
  let (a, b) = randomPair(Pairs-1)
  echo("Swapping ", MNames[a], " & ", MNames[b], " partners")
  swap(contPairs[a], contPairs[b])
  swap(recPairs[contPairs[a]], recPairs[contPairs[b]])

proc checkPairStability(contPairs, recPairs: seq[int]): bool =
  for c in 0..<Pairs: # each contender
    let curPairScore = ContenderPrefs[c].find(contPairs[c]) # pref. score for current pair
    for preferredRec in 0..<curPairScore: # try every recipient with higher score
      let
        checkedRec = ContenderPrefs[c][preferredRec]
        curRecPair = recPairs[checkedRec] # current pair of checked recipient
      # if score of the curRecPair is worse (>) than score of checked contender
      if RecipientPrefs[checkedRec][curRecPair] > RecipientPrefs[checkedRec][c]:
        echo("💔 ", MNames[c], " prefers ", FNames[checkedRec], " over ", FNames[contPairs[c]])
        echo("💔 ", FNames[checkedRec], " prefers ", MNames[c], " over ", MNames[curRecPair])
        echo "✗ Unstable"
        return false # unstable
  echo "✓ Stable"
  result = true

when isMainModule:
  var (contPairs, recPairs) = pair()
  printCoupleNames(contPairs)
  echo "Current pair analysis:"
  discard checkPairStability(contPairs, recPairs)
  perturbPairs(contPairs, recPairs)
  printCoupleNames(contPairs)
  echo "Current pair analysis:"
  discard checkPairStability(contPairs, recPairs)
