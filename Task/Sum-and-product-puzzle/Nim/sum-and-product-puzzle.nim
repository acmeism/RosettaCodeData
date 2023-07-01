import sequtils, sets, sugar, tables

var
  xycandidates = toSeq(2..98)
  sums = collect(initHashSet, for s in 5..100: {s})   # Set of possible sums.
  factors: Table[int, seq[(int, int)]]                # Mapping product -> list of factors.

# Build the factor mapping.
for i in 0..<xycandidates.high:
  let x = xycandidates[i]
  for j in (i + 1)..xycandidates.high:
    let y = xycandidates[j]
    factors.mgetOrPut(x * y, @[]).add (x, y)

iterator terms(n: int): (int, int) =
  ## Yield the possible terms (x, y) of a given sum.
  for x in 2..(n - 1) div 2:
    yield (x, n - x)

# S says "P does not know X and Y."
# => For every decomposition of S, there is no product with a single decomposition.
for s in toSeq(sums):
  for (x, y) in s.terms():
    let p = x * y
    if factors[p].len == 1:
      sums.excl s
      break

# P says "Now I know X and Y."
# => P has only one decomposition with sum in "sums".
for p in toSeq(factors.keys):
  var sums = collect(initHashSet):
               for (x, y) in factors[p]:
                 if x + y in sums: {x + y}
  if card(sums) > 1: factors.del p

# S says "Now I also know X and Y."
# => S has only one decomposition with product in "factors".
for s in toSeq(sums):
  var prods = collect(initHashSet):
                for (x, y) in s.terms():
                  if x * y in factors: {x * y}
  if card(prods) > 1: sums.excl s

# Now, combine the sums and the products.
for s in sums:
  for (x, y) in s.terms:
    if x * y in factors: echo (x, y)
