func isUnique(a, b, c, d, e, f, g: uint8): bool =
  a != b and a != c and a != d and a != e and a != f and a != g and
    b != c and b != d and b != e and b != f and b != g and
    c != d and c != e and c != f and c != g and
    d != e and d != f and d != f and
    e != f and e != g and
    f != g

func isSolution(a, b, c, d, e, f, g: uint8): bool =
  let sum = a + b
  sum == b + c + d and sum == d + e + f and sum == f + g

func fourSquares(l, h: uint8, unique: bool): seq[array[7, uint8]] =
  for a in l..h:
    for b in l..h:
      for c in l..h:
        for d in l..h:
          for e in l..h:
            for f in l..h:
              for g in l..h:
                if (not unique or isUnique(a, b, c, d, e, f, g)) and
                   isSolution(a, b, c, d, e, f, g):
                  result &= [a, b, c, d, e, f, g]

proc printFourSquares(l, h: uint8, unique = true) =
  let solutions = fourSquares(l, h, unique)

  if unique:
    for s in solutions:
      echo s

  echo solutions.len, (if unique: " " else: " non-"), "unique solutions in ",
     l, " to ", h, " range\n"

when isMainModule:
  printFourSquares(1, 7)
  printFourSquares(3, 9)
  printFourSquares(0, 9, unique = false)
