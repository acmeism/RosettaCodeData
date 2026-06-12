import std/[strformat, strutils]

proc expDigitalSum(showFirst, minWays, maxPower: Natural) =
  var i = 1
  var shown = 0
  while shown < showFirst:
    inc i
    var n = @[i]
    var res: seq[string]
    for p in 2..maxPower:
      var ds, carry = 0
      for j in 0..n.high:
        carry += n[j] * i
        let d = carry mod 10
        carry = carry div 10
        n[j] = d
        ds += d
      while carry != 0:
        let d = carry mod 10
        carry = carry div 10
        n.add d
        ds += d
      if p > 10 and ds > 2 * i: break
      if ds == i: res.add &"{i}^{p}"
    if res.len >= minWays:
      echo res.join(", ")
      inc shown

echo "First twenty-five integers that are equal to the " &
     "digital sum of that integer raised to some power:"
expDigitalSum(25, 1, 100)
echo &"\nFirst thirty that satisfy that condition in three or more ways:"
expDigitalSum(30, 3, 500)
