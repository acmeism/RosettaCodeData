import sets, strformat, strutils


func isOneAway(word1, word2: string): bool =
  ## Return true if "word1" and "word2" has only one letter of difference.
  for i in 0..word1.high:
    if word1[i] != word2[i]:
      if result: return false   # More than one letter of difference.
      else: result = true       # One letter of difference, for now.

var words: array[1..22, HashSet[string]]  # Set of words sorted by length.

for word in "unixdict.txt".lines:
  words[word.len].incl word


proc path(start, target: string): seq[string] =
  ## Return a path from "start" to "target" or an empty list
  ## if there is no possible path.
  let lg = start.len
  doAssert target.len == lg, "Source and destination must have same length."
  doAssert start in words[lg], "Source must exist in the dictionary."
  doAssert target in words[lg], "Destination must exist in the dictionary."

  var currPaths = @[@[start]]         # Current list of paths found.
  var pool = words[lg]                # List of possible words to use.

  while true:
    var newPaths: seq[seq[string]]    # Next list of paths.
    var added: HashSet[string]        # Set of words added during the round.
    for candidate in pool:
      for path in currPaths:
        if candidate.isOneAway(path[^1]):
          let newPath = path & candidate
          if candidate == target:
            # Found a path.
            return newPath
          else:
            # Not the target. Add a new path.
            newPaths.add newPath
            added.incl candidate
            break
    if newPaths.len == 0: break       # No path.
    currPaths = move(newPaths)        # Update list of paths.
    pool.excl added                   # Remove added words from pool.


when isMainModule:
  for (start, target) in [("boy", "man"), ("girl", "lady"), ("john", "jane"),
                          ("child", "adult"), ("cat", "dog"), ("lead", "gold"),
                          ("white", "black"), ("bubble", "tickle")]:
    let path = path(start, target)
    if path.len == 0:
      echo &"No path from “{start}” to “{target}”."
    else:
      echo path.join(" → ")
