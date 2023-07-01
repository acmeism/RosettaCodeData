import strformat

const

  D = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
       [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
       [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
       [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
       [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
       [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
       [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
       [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
       [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
       [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]]

  Inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9]

  P = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
       [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
       [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
       [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
       [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
       [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
       [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
       [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]]

type Digit = 0..9

proc verhoeff[T: SomeInteger](n: T; validate, verbose = false): T =
  ## Compute or validate a check digit.
  ## Return the check digit if computation or the number with the check digit
  ## removed if validation.
  ## If not in verbose mode, an exception is raised if validation failed.

  doAssert n >= 0, "Argument must not be negative."

  # Extract digits.
  var digits: seq[Digit]
  if not validate: digits.add 0
  var val = n
  while val != 0:
    digits.add val mod 10
    val = val div 10

  if verbose:
    echo if validate: &"Check digit validation for {n}:" else: &"Check digit computation for {n}:"
    echo " i  ni  p(i, ni)  c"

  # Compute c.
  var c = 0
  for i, ni in digits:
    let p = P[i mod 8][ni]
    c = D[c][p]
    if verbose: echo &"{i:2}   {ni}     {p}      {c}"

  if validate:
    if verbose:
      let verb = if c == 0: "is" else: "is not"
      echo &"Validation {verb} successful.\n"
    elif c != 0:
      raise newException(ValueError, &"Check digit validation failed for {n}.")
    result = n div 10

  else:
    result = Inv[c]
    if verbose: echo &"The check digit for {n} is {result}.\n"


for n in [236, 12345]:
  let d = verhoeff(n, false, true)
  discard verhoeff(10 * n + d, true, true)
  discard verhoeff(10 * n + 9, true, true)

let n = 123456789012
let d = verhoeff(n)
echo &"Check digit for {n} is {d}."
discard verhoeff(10 * n + d, true)
echo &"Check digit validation was successful for {10 * n + d}."
try:
  discard verhoeff(10 * n + 9, true)
except ValueError:
  echo getCurrentExceptionMsg()
