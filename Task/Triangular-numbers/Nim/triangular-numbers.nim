import std/[math, strformat, strutils]


proc printNSimplexNumbers(r, count, width: Positive; title: string) =
  ## Print the first "count" terms of the "r-simplex" sequence
  ## using "width" characters.
  echo title
  for n in 1..count:
    stdout.write align($binom(n + r - 1, r), width)
    stdout.write if n mod 5 == 0: '\n' else: ' '
  echo()

printNSimplexNumbers(2, 30, 3, "First 30 triangular numbers:")
printNSimplexNumbers(3, 30, 4, "First 30 tetrahedral numbers:")
printNSimplexNumbers(4, 30, 5, "First 30 pentatopic numbers:")
printNSimplexNumbers(12, 30, 10, "First 30 12-simplex numbers:")


func triangularRoot(x: float): float =
  ## Return the triangular root of "x".
  (sqrt(8 * x + 1) - 1) * 0.5

func tetrahedralRoot(x: float): float =
  ## Return the tetrahedral root of "x".
  let t1 = 3 * x
  let t2 = sqrt(t1 * t1 - 1 / 27)
  result = cbrt(t1 + t2) + cbrt(t1 - t2) - 1

func pentatopicRoot(x: float): float =
  ## Return the pentatopic root of "x".
  (sqrt(5 + 4 * sqrt(24 * x + 1)) - 3) * 0.5

for n in [int64 7140, 21408696, 26728085384, 14545501785001]:
  echo &"Roots of {n}:"
  for (title, f) in {"triangular: ": triangularRoot,
                     "tetrahedral:": tetrahedralRoot,
                     "pentatopic: ": pentatopicRoot}:
    echo &"  {title} {f(n.float):.6f}"
  echo()
