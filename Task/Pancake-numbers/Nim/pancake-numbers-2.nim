import sequtils, strformat, strutils, tables

type
  StepTable = TableRef[seq[int], int]
  Result = tuple[steps: int; example: seq[int]]

func findMax(t: StepTable): Result =
  result.steps = -1
  for example, steps in t.pairs:
    if steps > result.steps:
      result = (steps, example)

func partialReversed(arr: openArray[int]; pos: int): seq[int] =
  result.setlen(arr.len)
  for i in 0..<pos:
    result[i] = arr[pos - 1 - i]
  for i in pos..arr.high:
    result[i] = arr[i]

func pancake(n: int): Result =
  var goalStack = toSeq(1..n)
  var stacks, newStacks: StepTable = newTable({goalStack: 0})
  var numStacks = 1
  for i in 1..1000:
    var nextStacks = new(StepTable)
    for arr, steps in newStacks.pairs:
      for pos in 2..n:
        let newStack = partialReversed(arr, pos)
        if newStack notin stacks:
          nextStacks[newStack] = i
    newStacks = nextStacks
    for key, value in newStacks:
      stacks[key] = value
    let perms = stacks.len
    if perms == numStacks:
      return stacks.findMax()
    numStacks = perms

for n in 1..10:
  let (steps, example) = pancake(n)
  echo &"p({n:>2}) = {steps:>2}    example: ", example.join(", ")
