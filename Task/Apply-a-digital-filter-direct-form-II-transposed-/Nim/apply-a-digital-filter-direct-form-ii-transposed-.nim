import strformat

func filter(a, b, signal: openArray[float]): seq[float] =

  result.setLen(signal.len)

  for i in 0..signal.high:
    var tmp = 0.0
    for j in 0..min(i, b.high):
      tmp += b[j] * signal[i - j]
    for j in 1..min(i, a.high):
      tmp -= a[j] * result[i - j]
    tmp /= a[0]
    result[i] = tmp

#———————————————————————————————————————————————————————————————————————————————————————————————————

let a = [1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17]
let b = [0.16666667, 0.5, 0.5, 0.16666667]

let signal = [-0.917843918645,  0.141984778794, 1.20536903482,   0.190286794412,
              -0.662370894973, -1.00700480494, -0.404707073677,  0.800482325044,
               0.743500089861,  1.01090520172,  0.741527555207,  0.277841675195,
               0.400833448236, -0.2085993586,  -0.172842103641, -0.134316096293,
               0.0259303398477, 0.490105989562, 0.549391221511,  0.9047198589]

let result = filter(a, b, signal)
for i in 0..result.high:
  stdout.write fmt"{result[i]: .8f}"
  stdout.write if (i + 1) mod 5 != 0: ", " else: "\n"
