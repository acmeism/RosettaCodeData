import bitops, strutils

type Nimber = Natural

func hpo2(n: Nimber): Nimber =
  ## Return the highest power of 2 that divides a given number.
  n and -n

func lhpo2(n: Nimber): Nimber =
  ## Return the base 2 logarithm of the highest power of 2 dividing a given number.
  fastLog2(hpo2(n))

func ⊕(x, y: Nimber): Nimber =
  ## Return the nim-sum of two nimbers.
  x xor y

func ⊗(x, y: Nimber): Nimber =
  ## Return the nim-product of two nimbers.

  if x < 2 and y < 2: return x * y

  var h = hpo2(x)
  if x > h:
    return ⊗(h, y) xor ⊗(x xor h, y)  # Recursively break "x" into its powers of 2.
  if hpo2(y) < y:
    return ⊗(y, x)    # Recursively break "y" into its powers of 2 by flipping the operands.

  # Now both "x" and "y" are powers of two.
  let comp = lhpo2(x) * lhpo2(y)
  if comp == 0: return x * y    # No Fermat number in common.
  h = hpo2(comp)
  # A fermat number square is its sequimultiple.
  result = ⊗(⊗(x div (1 shl h), y div (1 shl h)), 3 * (1 shl (h - 1)))


when isMainModule:

  for (opname, op) in [("⊕", ⊕), ("⊗", ⊗)]:
    stdout.write ' ', opname, " |"
    for i in 0..15: stdout.write ($i).align(3)
    stdout.write "\n--- -", repeat('-', 48), '\n'
    for b in 0..15:
      stdout.write ($b).align(2), " |"
      for a in 0..15:
        stdout.write ($op(a, b)).align(3)
      stdout.write '\n'
    echo ""

  const A = 21508
  const B = 42689
  echo "$1 ⊕ $2 = $3".format(A, B, ⊕(A, B))
  echo "$1 ⊗ $2 = $3".format(A, B, ⊗(A, B))
