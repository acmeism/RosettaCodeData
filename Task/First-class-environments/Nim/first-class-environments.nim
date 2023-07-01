import strformat

const Jobs = 12

type Environment = object
  sequence: int
  count: int

var
  env: array[Jobs, Environment]
  sequence, count: ptr int

#---------------------------------------------------------------------------------------------------

proc hail() =
  stdout.write fmt"{sequence[]: 4d}"
  if sequence[] == 1: return
  inc count[]
  sequence[] = if (sequence[] and 1) != 0: 3 * sequence[] + 1
               else: sequence[] div 2

#---------------------------------------------------------------------------------------------------

proc switchTo(id: int) =
  sequence = addr(env[id].sequence)
  count = addr(env[id].count)

#---------------------------------------------------------------------------------------------------

template forAllJobs(statements: untyped): untyped =
  for i in 0..<Jobs:
    switchTo(i)
    statements

#———————————————————————————————————————————————————————————————————————————————————————————————————

for i in 0..<Jobs:
  switchTo(i)
  env[i].sequence = i + 1

var terminated = false
while not terminated:

  forAllJobs:
    hail()
  echo ""

  terminated = true
  forAllJobs:
    if sequence[] != 1:
      terminated = false
      break

echo ""
echo "Counts:"
forAllJobs:
  stdout.write fmt"{count[]: 4d}"
echo ""
