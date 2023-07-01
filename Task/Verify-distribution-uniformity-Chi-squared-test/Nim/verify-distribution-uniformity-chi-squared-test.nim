import lenientops, math, stats, strformat, sugar

func simpson38(f: (float) -> float; a, b: float; n: int): float =
  let h = (b - a) / n
  let h1 = h / 3
  var sum = f(a) + f(b)
  for i in countdown(3 * n - 1, 1):
    if i mod 3 == 0:
      sum += 2 * f(a + h1 * i)
    else:
      sum += 3 * f(a + h1 * i)
  result = h * sum / 8

func gammaIncQ(a, x: float): float =
  let aa1 = a - 1
  func f(t: float): float = pow(t, aa1) * exp(-t)
  var y = aa1
  let h = 1.5e-2
  while f(y) * (x - y) > 2e-8 and y < x:
    y += 0.4
  if y > x: y = x
  result = 1 - simpson38(f, 0, y, (y / h / gamma(a)).toInt)

func chi2ud(ds: openArray[int]): float =
  let expected = mean(ds)
  var s = 0.0
  for d in ds:
    let x = d.toFloat - expected
    s += x * x
  result = s / expected

func chi2p(dof: int; distance: float): float =
  gammaIncQ(0.5 * dof, 0.5 * distance)

const SigLevel = 0.05

proc utest(dset: openArray[int]) =

  echo "Uniform distribution test"
  let s = sum(dset)
  echo " dataset:", dset
  echo " samples:                      ", s
  echo " categories:                   ", dset.len

  let dof = dset.len - 1
  echo " degrees of freedom:           ", dof

  let dist = chi2ud(dset)
  echo " chi square test statistic:    ", dist

  let p = chi2p(dof, dist)
  echo " p-value of test statistic:    ", p

  let sig = p < SigLevel
  echo &" significant at {int(SigLevel * 100)}% level?      {sig}"
  echo &" uniform?                      {not sig}\n"


for dset in [[199809, 200665, 199607, 200270, 199649],
             [522573, 244456, 139979, 71531, 21461]]:
  utest(dset)
