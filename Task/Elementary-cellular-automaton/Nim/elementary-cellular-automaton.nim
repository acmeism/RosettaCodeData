import bitops

const
  Size = 32
  LastBit = Size - 1
  Lines = Size div 2
  Rule = 90

type State = int    # State is represented as an int and will be used as a bit string.

#---------------------------------------------------------------------------------------------------

template bitVal(state: State; n: typed): int =
  ## Return the value of a bit as an int rather than a bool.
  ord(state.testBit(n))

#---------------------------------------------------------------------------------------------------

proc ruleTest(x: int): bool =
  ## Return true if a bit must be set.
  (Rule and 1 shl (7 and x)) != 0

#---------------------------------------------------------------------------------------------------

proc evolve(state: var State) =
  ## Compute next state.

  var newState: State  # All bits cleared by default.
  if ruleTest(state.bitVal(0) shl 2 or state.bitVal(LastBit) shl 1 or state.bitVal(LastBit-1)):
    newState.setBit(LastBit)
  if ruleTest(state.bitVal(1) shl 2 or state.bitVal(0) shl 1 or state.bitVal(LastBit)):
    newState.setBit(0)
  for i in 1..<LastBit:
    if ruleTest(state.bitVal(i + 1) shl 2 or state.bitVal(i) shl 1 or state.bitVal(i - 1)):
      newState.setBit(i)
  state = newState

#---------------------------------------------------------------------------------------------------

proc show(state: State) =
  ## Show the current state.
  for i in countdown(LastBit, 0):
    stdout.write if state.testbit(i): '*' else: ' '
  echo ""

#———————————————————————————————————————————————————————————————————————————————————————————————————

var state: State
state.setBit(Lines)
echo "Rule ", Rule
for _ in 1..Lines:
  show(state)
  evolve(state)
