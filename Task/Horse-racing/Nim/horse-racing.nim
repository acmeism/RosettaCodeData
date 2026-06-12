import algorithm, math, strformat, strutils

# Ratings on past form, assuming a rating of 100 for horse A.
var
  a = 100.0
  b = a - 8 - 2 * 2       # carried 8 lbs less, finished 2 lengths behind.
  c = a + 4 - 2 * 3.5
  d = a - 4 - 10 * 0.4    # based on relative weight and time.
  e = d + 7 - 2 * 1
  f = d + 11 - 2 * (4 - 2)
  g = a - 10  + 10 * 0.2
  h = g + 6 - 2 * 1.5
  i = g + 15 - 2 * 2

# Adjustments to ratings for current race.
b += 4
c -= 4
h += 3
var j = a - 3 + 10 * 0.2

# Filly's allowance to give weight adjusted weighting.
b += 3
d += 3
i += 3
j += 3

# Create table mapping horse to its weight adjusted rating and whether colt.
type Pair = tuple[key: char; value: tuple[rating: float; colt: bool]]
let list: array[10, Pair] = {'A': (a, true), 'B': (b, false),
                             'C': (c, true), 'D': (d, false),
                             'E': (e, true), 'F': (f, true),
                             'G': (g, true), 'H': (h, true),
                             'I': (i, false), 'J': (j, false)}

# Sort in descending order of rating.
let slist = list.sortedByIt(-it.value.rating)

# Show expected result of race.
echo "Race 4\n"
echo "Pos Horse  Weight  Dist  Sex"
var pos = ""
for i, (key, value) in slist:
  let wt = if value.colt: "9.00" else: "8.11"
  var dist = 0.0
  if i > 0: dist = (slist[i-1].value.rating - value.rating) * 0.5
  pos = if i == 0 or dist > 0: $(i + 1)
        elif not pos.endsWith("="): $i & '='
        else: pos
  let sx = if value.colt: "colt" else: "filly"
  echo &"{pos:<2}  {key}      {wt}    {dist:3.1f}   {sx}"

# Weight adjusted rating of winner.
let wr = slist[0].value.rating

# Expected time of winner (relative to A's time in Race 1).
let t = 96 - (wr - 100) / 10
var min = int(t / 60)
var sec = t mod 60
echo &"\nTime {min} minute {sec:.1f} seconds"
