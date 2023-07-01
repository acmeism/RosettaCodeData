import intsets, strutils, times

proc mianchowla(n: Positive): seq[int] =
  result = @[1]
  var sums = [2].toIntSet()
  var candidate = 1

  while result.len < n:
    # Test successive candidates.
    var fit = false
    result.add 0    # Make room for next value.
    while not fit:
      inc candidate
      fit = true
      result[^1] = candidate
      # Check the sums.
      for val in result:
        if val + candidate in sums:
          # Failed to satisfy criterium.
          fit = false
          break
    # Add the new sums to the set of sums.
    for val in result:
      sums.incl val + candidate

let t0 = now()
let seq100 = mianchowla(100)
echo "The first 30 terms of the Mian-Chowla sequence are:"
echo seq100[0..29].join(" ")
echo ""
echo "Terms 91 to 100 of the sequence are:"
echo seq100[90..99].join(" ")

echo ""
echo "Computation time: ", (now() - t0).inMilliseconds, " ms"
