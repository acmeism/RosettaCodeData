import strformat

iterator feigenbaum(): tuple[n: int; δ: float] =
  ## Yield successive approximations of Feigenbaum constant.

  const
    MaxI = 13
    MaxJ = 10
  var
    a1 = 1.0
    a2 = 0.0
    δ = 3.2

  for i in 2..MaxI:
    var a = a1 + (a1 - a2) / δ
    for j in 1..MaxJ:
      var x, y = 0.0
      for _ in 1..(1 shl i):
        y = 1 - 2 * y * x
        x = a - x * x
      a -= x / y

    δ = (a1 - a2) / (a - a1)
    a2 = a1
    a1 = a
    yield (i, δ)

echo " i         δ"
for n, δ in feigenbaum():
  echo fmt"{n:2d}    {δ:.8f}"
