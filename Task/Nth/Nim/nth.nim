const suffix = ["th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"]

proc nth(n): string =
  $n & "'" & (if n mod 100 <= 10 or n mod 100 > 20: suffix[n mod 10] else: "th")

for j in countup(0, 1000, 250):
  for i in j..j+24:
    stdout.write nth(i), " "
  echo ""
