import std/[random, strformat]

randomize()

proc simulate(verbose: bool): (int, int) =
  if verbose:
    echo "Seconds   Steps behind   Steps ahead"
  var curr = 1    # Number of current step.
  var last = 100  # Number of last step.
  var t = 0
  while true:
    inc t
    inc curr
    if curr > last:
      return (t, last)        # Escaped!
    # Add new steps.
    for i in 1..5:
      let n = rand(1..last)
      if n < curr: inc curr   # Behind current step.
      inc last
    if verbose and t in 600..609:
      echo &"{t:^7}   {curr:^12}   {last - curr:^12}"
      if t == 609: return     # This part is terminated.

# First part of the task.
discard simulate(true)
echo()

# Second part of the task.
var tSum, stepSum = 0
for _ in 1..10_000:
  let (t, n) = simulate(false)
  tSum += t
  stepSum += n
echo &"Average seconds taken: {tSum / 10_000}"
echo &"Average final length of staircase: {stepSum / 10_000}"
