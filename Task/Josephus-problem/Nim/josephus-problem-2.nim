func prisonerPos(n, k: Positive): int =
  ## The result is computed backwards. We start from the winner at
  ## position 0 on last round and compute its position on previous rounds.
  var pos = 0
  for i in 2..n:
    pos = (pos + k) mod i
  result = pos

echo "Survivor: ", prisonerPos(5, 2)
echo "Survivor: ", prisonerPos(41, 3)
