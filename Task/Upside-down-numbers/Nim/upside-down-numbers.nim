import std/[math, strformat, strutils, sugar]

iterator upsideDownNumbers(): (int, int) =
  ## Generate upside-down numbers (OEIS A299539).
  const
    Wrappings = [(1, 9), (2, 8), (3, 7), (4, 6),
                 (5, 5), (6, 4), (7, 3), (8, 2), (9, 1)]
  var
    evens = @[19, 28, 37, 46, 55, 64, 73, 82, 91]
    odds = @[5]
    oddIndex, evenIndex = 0
    ndigits = 1
    count = 0

  while true:
    if ndigits mod 2 == 1:
      if odds.len > oddIndex:
        inc count
        yield (count, odds[oddIndex])
        inc oddIndex
      else:
        # Build next odds, but switch to evens.
        odds = collect:
                 for (hi, lo) in Wrappings:
                   for i in odds:
                     hi * 10^(ndigits + 1) + 10 * i + lo
        inc ndigits
        oddIndex = 0
    else:
      if evens.len > evenIndex:
        inc count
        yield (count, evens[evenIndex])
        inc evenIndex
      else:
        # Build next evens, but switch to odds.
        evens = collect:
                  for (hi, lo) in Wrappings:
                    for i in evens:
                      hi * 10^(ndigits + 1) + 10 * i + lo
        inc ndigits
        evenIndex = 0

echo "First fifty upside-downs:"
for (udcount, udnumber) in upsideDownNumbers():
  if udcount <= 50:
    stdout.write &"{udnumber:5}"
    if udcount mod 10 == 0: echo()
  elif udcount == 500:
    echo &"\nFive hundredth: {insertSep($udnumber)}"
  elif udcount == 5_000:
    echo &"Five thousandth: {insertSep($udnumber)}"
  elif udcount == 50_000:
    echo &"Fifty thousandth: {insertSep($udnumber)}"
  elif udcount == 500_000:
    echo &"Five hundred thousandth: {insertSep($udnumber):}"
  elif udcount == 5_000_000:
    echo &"Five millionth: {insertSep($udnumber):}"
    break
