import std/algorithm

const
  M = 1000      # Maximum area.
  N = M div 2   # Maximum half area.

var isOHalloran: array[3..N, bool]
isOHalloran.fill(true)

for length in 1..N:
  for width in 1..length:
    let plw = length * width
    if plw > N: break
    let slw = length + width
    for height in 1..width:
      let halfArea = plw + height * slw
      if halfArea > N: break
      isOHalloran[halfArea] = false

echo "All known O'Halloran numbers:"
for n in 3..N:
  if isOHalloran[n]:
    stdout.write 2 * n, ' '
echo()
