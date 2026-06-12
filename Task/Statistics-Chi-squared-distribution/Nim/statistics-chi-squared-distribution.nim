import std/[math, strformat, sugar]

func χ²(x: float; k: int): float =
  ## χ² function, the probability distribution function (pdf) for χ².
  if x > 0: x.pow(k / 2 - 1) * exp(-x/2) / (2.pow(k / 2) * gamma(k / 2)) else: 0

func gammaCdf(k, x: float): float =
  ## Lower incomplete gamma by series formula with gamma.
  for m in 0..99:
    result += x^m / gamma(k + m.toFloat + 1)
  result *= pow(x, k) * exp(-x)

func cdfχ²(x: float; k: int): float =
  ## Cumulative probability function (cdf) for χ².
  if x > 0 and k > 0: gammaCdf(k / 2, x / 2) else: 0


echo "    Values of the χ2 probability distribution function"
echo " x/k    1         2         3         4         5"
for x in 0..10:
  stdout.write &"{x:2} "
  for k in 1..5:
    stdout.write &"{χ²(x.toFloat, k):10.6f}"
  echo()

echo()
echo "    Values for χ2 with 3 degrees of freedom"
echo "χ²    cum pdf    p-value"
for x in [1, 2, 4, 8, 16, 32]:
  let cdf = cdfχ²(x.toFloat, 3)
  echo &"{x:2} {cdf:10.6f} {1 - cdf:10.6f}"

const
  AirportData = [[float 77, 23], [float 88, 12], [float 79, 21], [float 81, 19]]
  Expected = [[81.25, 18.75], [81.25, 18.75], [81.25, 18.75], [81.25, 18.75]]

var dtotal = 0.0

for pos in [0, 1]:
  for i, d in AirportData:
    dtotal += (d[pos] - Expected[i][pos])^2 / Expected[i][pos]

echo()
echo &"For the airport data, diff total is {dtotal:.6f}, " &
     &"χ² is {χ²(dtotal, 3):.6f}, p value is {cdfχ²(dtotal, 3):.6f}."


### Stretch task ###

import gnuplot
let x = collect(for n in 0..9999: n / 1000)
withGnuplot:
  cmd "set multiplot"
  cmd "set yrange [-0.02:0.5]"
  for k in 0..3:
    let y = collect(for p in x: χ²(p, k))
    plot(x, y, &"k = {k}", "with lines")
