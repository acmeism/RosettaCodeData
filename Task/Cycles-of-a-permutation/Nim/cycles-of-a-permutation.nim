import std/[algorithm, math, sequtils, setutils, strutils, sugar, tables]

type
  Perm* = object
    a: seq[int]
  Cycle* = seq[int]

template isEven(n: int): bool = (n and 1) == 0

func newPerm*(len: Natural = 0): Perm =
  ## Create a Perm with given length.
  result.a = newSeq[int](len)

func newPerm*(a: openArray[int]): Perm =
  ## Create a Perm with given values.
  assert sorted(a) == toSeq(1..a.len), "Perm should be a shuffled 1-based range"
  result.a = a.toSeq

template len*(perm: Perm): int = perm.a.len

template `[]`*(perm: Perm; idx: Natural): int =
  ## Return the element at given one base index.
  perm.a[idx - 1]

template `[]=`*(perm: var Perm; idx: Natural; val: int) =
  ## Set the element at given one base index.
  perm.a[idx - 1] = val

iterator pairs*(perm: Perm): (int, int) =
  ## Yield the couples (one-based-index, val).
  for i in 1..perm.len:
    yield (i, perm[i])

func inv*(perm: Perm): Perm =
  ## Return the inverse of a Perm.
  result = newPerm(perm.len)
  for i in 1..perm.len:
    let j = perm[i]
    result[j] = i

func cycles*(perm: Perm; includeSingles = false): seq[Cycle] =
  ## Get cycles of a Perm permutation as a sequence of integer
  ## sequences, optionally with singles.
  var ptable = collect(for (i, val) in perm.pairs: {i: val})
  for i in 1..perm.len:
    var j: int
    if ptable.pop(i, j):
      var c = @[i]
      while i != j:
        c.add j
        discard ptable.pop(j, j)
      if includeSingles or c.len > 1:
        result.add c

func cycleFormat*(perm: Perm; alfBettyForm = false): string =
  ## Stringify the Perm as its cycles, optionally in Rosetta Code task format.
  let p = if alfBettyForm: inv(perm) else: perm
  let cyclestrings = collect:
                       for c in p.cycles:
                         '(' & c.join(" ") & ')'
  result = cycleStrings.join(" ")

func oneLineFormat*(perm: Perm): string =
  ## Stringify the Perm in one-line permutation format.
  result = "[ " & perm.a.join(" ") & " ]"

func sign*(perm: Perm): int =
  ## Return the sign of the permutation.
  var sum = 0
  for c in perm.cycles:
    sum += ord(c.len.isEven)
  result = if sum.isEven: 1 else: -1

func order*(perm: Perm): int =
  ## Return the order of permutation for Perm.
  lcm(perm.cycles.mapIt(it.len))

func `*`*(p1, p2: Perm): Perm =
  ## Return the composition of Perm permutations with the * operator.
  assert p1.len == p2.len, "permutations must be of same length"
  result = newPerm(collect(for i in 1..p1.len: p1[p2[i]]))

func toPerm*(cycles: seq[Cycle]; addSingles = true): Perm =
  ## Create a Perm from a sequence of cycles.
  var cycles = cycles
  var elements = collect:
                   for c in cycles:
                     for e in c: e
  let allPossible = toSeq(1..elements.len)
  if addSingles:
    let missings = collect:
                     for x in allPossible:
                       if x notin elements: x
    for elem in missings:
      cycles.add @[elem]
      elements.add elem

  assert sorted(elements) == allPossible, "invalid cycles for creating a Perm"
  result = newPerm(elements.len)
  for c in cycles:
    let length = c.len
    for i in 1..length:
      let j = c[i]
      let n = c[(i + 1) mod length]
      result[j] = n

func toPerm*(s: string): Perm =
  ## Create a Perm from a string with only one of each of its letters.
  let letters = sorted(s).deduplicate(true)
  result = newPerm(collect(for c in s: letters.find(c) + 1))

func toPerm*(s1, s2: string): Perm  =
  ## Create a Perm from two strings permuting first string to the second one.
  result = newPerm(collect(for c in s2: s1.find(c) + 1))

func permutedString*(s: string; p: Perm): string =
  ## Create a permuted string from another string using Perm p.
  collect(for i in p.a: s[i - 1]).join("")

when isMainModule:

  let
    days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    dayStrings = ["HANDYCOILSERUPT", "SPOILUNDERYACHT", "DRAINSTYLEPOUCH",
                  "DITCHSYRUPALONE", "SOAPYTHIRDUNCLE", "SHINEPARTYCLOUD", "RADIOLUNCHTYPES"]
    dayPerms = collect:
                 for i in 0..6:
                   (toPerm(dayStrings[(i + 6) mod 7], dayStrings[i]))

  echo "On Thursdays Alf and Betty should rearrange"
  echo "their letters using these cycles:      ", dayPerms[3].cycleFormat(true), '\n'
  echo "So that ", dayStrings[2], " becomes ", daystrings[3], '\n'
  echo "or they could use the one-line notation:  ", dayPerms[3].oneLineFormat(), "\n\n"
  echo "To revert to the Wednesday arrangement they"
  echo "should use these cycles:      ", inv(dayPerms[3]).cycleformat(true), '\n'
  echo "or with the one-line notation:  ", inv(dayperms[3]).oneLineFormat(), '\n'
  echo "So that ", dayStrings[3], " becomes ", dayStrings[2], "\n\n"
  echo "Starting with the Sunday arrangement and applying each of the daily"
  echo "permutations consecutively, the arrangements will be:\n\n      ", dayStrings[6]
  for i in 0..6:
    if i == 6: echo()
    echo days[i], ":  ", permutedString(daystrings[(i + 6) mod 7], dayPerms[i])

  echo "\n\nTo go from Wednesday to Friday in a single step they should use these cycles: "
  echo toPerm(dayStrings[2], dayStrings[4]).cycleformat(true), '\n'
  echo "So that ", dayStrings[2], " becomes ", dayStrings[4], "\n\n"
  echo "These are the signatures of the permutations:\n"
  echo "  Mon Tue Wed Thu Fri Sat Sun"
  for i in 0..6:
    stdout.write align($toPerm(dayStrings[(i + 6) mod 7], daystrings[i]).sign, 4)

  echo "\n\nThese are the orders of the permutations:\n"
  echo "  Mon Tue Wed Thu Fri Sat Sun"
  for i in 0..6:
    stdout.write align($dayPerms[i].order, 4)

  echo "\n\nApplying the Friday cycle to a string 10 times:\n"
  let pFri = dayperms[4]
  var spe = "STOREDAILYPUNCH"
  echo "   ", spe
  for i in 1..10:
    spe = permutedString(spe, pFri)
    echo align($i, 2), ' ', spe, if i == 9: "\n" else: ""
