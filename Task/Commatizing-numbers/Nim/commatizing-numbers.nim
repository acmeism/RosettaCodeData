import re
import strutils

let r = re"(\.[0-9]+|[1-9]([0-9]+)?(\.[0-9]+)?)"

#---------------------------------------------------------------------------------------------------

proc commatize(str: string; startIndex = 0; period = 3; sep = ","): string =

  result = str
  var dp, ip = ""

  if startIndex notin 0..str.high : return

  # Extract first number (if any).
  let (lowBound, highBound) = str.findBounds(r, startIndex)
  if lowBound < 0: return
  let match = str[lowBound..highBound]
  let splits = match.split('.')

  # Process integer part.
  ip = splits[0]
  if ip.len > period:
    var inserted = 0
    for i in countup(ip.high mod period + 1, ip.high, period):
      ip.insert(sep, i + inserted)
      inserted += sep.len

  # Process decimal part.
  if '.' in match:
    dp = splits[1]
    if dp.len > period:
      for i in countdown(dp.high div period * period, period, period):
        dp.insert(sep, i)
    ip &= '.' & dp

  # Replace the number by its "commatized" version.
  result[lowBound..highBound] = ip


#———————————————————————————————————————————————————————————————————————————————————————————————————

const Tests = [
      "123456789.123456789",
      ".123456789",
      "57256.1D-4",
      "pi=3.14159265358979323846264338327950288419716939937510582097494459231",
      "The author has two Z$100000000000000 Zimbabwe notes (100 trillion).",
      "-in Aus$+1411.8millions",
      "===US$0017440 millions=== (in 2000 dollars)",
      "123.e8000 is pretty big.",
      "The land area of the earth is 57268900(29% of the surface) square miles.",
      "Ain't no numbers in this here words, nohow, no way, Jose.",
      "James was never known as 0000000007",
      "Arthur Eddington wrote: I believe there are " &
        "15747724136275002577605653961181555468044717914527116709366231425076185631031296" &
        " protons in the universe.",
      "   $-140000±100 millions.",
      "6/9/1946 was a good year for some."]


echo Tests[0].commatize(period = 2, sep = "*")
echo Tests[1].commatize(period = 3, sep = "-")
echo Tests[2].commatize(period = 4, sep = "__")
echo Tests[3].commatize(period = 5, sep = " ")
echo Tests[4].commatize(sep = ".")

for n in 5..Tests.high:
  echo Tests[n].commatize()
