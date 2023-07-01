import algorithm

type Digit = range[0..9]

func digits(n: Natural): seq[Digit] =
  ## Return the list of digits of "n" in reverse order.
  if n == 0: return @[Digit 0]
  var n = n
  while n != 0:
    result.add n mod 10
    n = n div 10

func nextHighest(n: Natural): Natural =
  ## Find the next highest integer of "n".
  ## If none is found, "n" is returned.
  var d = digits(n) # Warning: in reverse order.
  var m = d[0]
  for i in 1..d.high:
    if d[i] < m:
      # Find the digit greater then d[i] and closest to it.
      var delta = m - d[i] + 1
      var best: int
      for j in 0..<i:
        let diff = d[j] - d[i]
        if diff > 0 and diff < delta:
          # Greater and closest.
          delta = diff
          best = j
      # Exchange digits.
      swap d[i], d[best]
      # Sort previous digits.
      d[0..<i] = sorted(d.toOpenArray(0, i - 1), Descending)
      break
    else:
      m = d[i]
  # Compute the value from the digits.
  for val in reversed(d):
    result = 10 * result + val


when isMainModule:
  for n in [0, 9, 12, 21, 12453, 738440, 45072010, 95322020]:
    echo n, " → ", nextHighest(n)
