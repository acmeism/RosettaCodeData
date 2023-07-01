import strformat, strutils, tables

type

  Sequence = seq[Natural]

  Context = object
    divisors: seq[int]
    subtractors: seq[int]
    seqCache: Table[int, Sequence]  # Mapping number -> sequence to reach 1.
    stepCache: Table[int, int]      # Mapping number -> number of steps to reach 1.


proc initContext(divisors, subtractors: openArray[int]): Context =
  ## Initialize a context.
  for d in divisors: doAssert d > 1, "divisors must be greater than 1."
  for s in subtractors: doAssert s > 0, "substractors must be greater than 0."
  result.divisors = @divisors
  result.subtractors = @subtractors
  result.seqCache[1] = @[Natural 1]
  result.stepCache[1] = 0


proc minStepsDown(context: var Context; n: Natural): Sequence =
  # Return a minimal sequence to reach the value 1.

  assert n > 0, "“n” must be positive."
  if n in context.seqCache: return context.seqCache[n]

  var
    minSteps = int.high
    minPath: Sequence

  for val in context.divisors:
    if n mod val == 0:
      var path = context.minStepsDown(n div val)
      if path.len < minSteps:
        minSteps = path.len
        minPath = move(path)

  for val in context.subtractors:
    if n - val > 0:
      var path = context.minStepsDown(n - val)
      if path.len < minSteps:
        minSteps = path.len
        minPath = move(path)

  result = n & minPath
  context.seqCache[n] = result


proc minStepsDownCount(context: var Context; n: Natural): int =
  ## Compute the mininum number of steps without keeping the sequence.

  assert n > 0, "“n” must be positive."
  if n in context.stepCache: return context.stepCache[n]

  result = int.high

  for val in context.divisors:
    if n mod val == 0:
      let steps = context.minStepsDownCount(n div val)
      if steps < result: result = steps

  for val in context.subtractors:
    if n - val > 0:
      let steps = context.minStepsDownCount(n - val)
      if steps < result: result = steps

  inc result
  context.stepCache[n] = result


template plural(n: int): string =
  if n > 1: "s" else: ""

proc printMinStepsDown(context: var Context; n: Natural) =
  ## Search and print the sequence to reach one.

  let sol = context.minStepsDown(n)
  stdout.write &"{n} takes {sol.len - 1} step{plural(sol.len - 1)}: "
  var prev = 0
  for val in sol:
    if prev == 0:
      stdout.write val
    elif prev - val in context.subtractors:
      stdout.write " - ", prev - val, " → ", val
    else:
      stdout.write " / ", prev div val, " → ", val
    prev = val
  stdout.write '\n'


proc maxMinStepsCount(context: var Context; nmax: Positive): tuple[steps: int; list: seq[int]] =
  ## Return the maximal number of steps needed for numbers between 1 and "nmax"
  ## and the list of numbers needing this number of steps.

  for n in 2..nmax:
    let nsteps = context.minStepsDownCount(n)
    if nsteps == result.steps:
      result.list.add n
    elif nsteps > result.steps:
      result.steps = nsteps
      result.list = @[n]


proc run(divisors, subtractors: openArray[int]) =
  ## Run the search for given divisors and subtractors.

  var context = initContext(divisors, subtractors)
  echo &"Using divisors: {divisors} and substractors: {subtractors}"
  for n in 1..10: context.printMinStepsDown(n)
  for nmax in [2_000, 20_000]:
    let (steps, list) = context.maxMinStepsCount(nmax)
    stdout.write if list.len == 1: &"There is 1 number " else: &"There are {list.len} numbers "
    echo &"below {nmax} that require {steps} steps: ", list.join(", ")


run(divisors = [2, 3], subtractors = [1])
echo ""
run(divisors = [2, 3], subtractors = [2])
