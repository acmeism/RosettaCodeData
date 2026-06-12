import math, stats, strutils, sugar

func sqr(f: float): float = f * f

func degreesFreedom(da1, da2: openArray[float]): float =
  let s1 = varianceS(da1)
  let s2 = varianceS(da2)
  let n1 = da1.len.toFloat
  let n2 = da2.len.toFloat
  let n = sqr(s1 / n1 + s2 / n2)
  let d = sqr(s1) / (n1 * n1 * (n1 - 1)) + sqr(s2) / (n2 * n2 * (n2 - 1))
  result = n / d

func welch(da1, da2: openArray[float]): float =
  let f = varianceS(da1) / da1.len.toFloat + varianceS(da2) / da2.len.toFloat
  result = (mean(da1) - mean(da2)) / sqrt(f)

func simpson(a, b: float; n: int; f: float -> float): float =
  let h = (b - a) / n.toFloat
  var sum = 0.0
  for i in 0..<n:
    let x = a + i.toFloat * h
    sum += (f(x) + 4 * f(x + h / 2) + f(x + h)) / 6
  result = sum * h

func p2Tail(da1, da2: openArray[float]): float =
  let ν = degreesFreedom(da1, da2)
  let t = welch(da1, da2)
  let g = exp(lGamma(ν / 2) + lGamma(0.5) - lGamma(ν / 2 + 0.5))
  let b = ν / (t * t + ν)
  proc f(r: float): float = pow(r, ν / 2 - 1) / sqrt(1 - r)
  result = simpson(0, b, 10000, f) / g    # n = 10000 seems more than enough here.


when isMainModule:

  const
    Da1 = [27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6,
           23.1, 19.6, 19.0, 21.7, 21.4]
    Da2 = [27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2,
           21.9, 22.1, 22.9, 20.5, 24.4]
    Da3 = [17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8]
    Da4 = [21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8,
           20.7, 21.7, 21.5, 22.5, 23.6, 21.5, 22.5, 23.5, 21.5, 21.8]
    Da5 = [19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0]
    Da6 = [28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7,
           23.2, 17.5, 20.6, 18.0, 23.9, 21.6, 24.3, 20.4, 24.0, 13.2]
    Da7 = [30.02, 29.99, 30.11, 29.97, 30.01, 29.99]
    Da8 = [29.89, 29.93, 29.72, 29.98, 30.02, 29.98]

    X = [3.0, 4.0, 1.0, 2.1]
    Y = [490.2, 340.0, 433.9]

  echo p2Tail(Da1, Da2).formatFloat(ffDecimal, 6)
  echo p2Tail(Da3, Da4).formatFloat(ffDecimal, 6)
  echo p2Tail(Da5, Da6).formatFloat(ffDecimal, 6)
  echo p2Tail(Da7, Da8).formatFloat(ffDecimal, 6)
  echo p2Tail(X, Y).formatFloat(ffDecimal, 6)
