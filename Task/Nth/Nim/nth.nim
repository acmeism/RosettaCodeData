const Suffix = ["th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"]

proc nth(n: Natural): string =
  $n & "'" & (if n mod 100 in 11..20: "th" else: Suffix[n mod 10])

for j in countup(0, 1000, 250):
  for i in j..j+24:
    stdout.write nth(i), " "
  echo ""
