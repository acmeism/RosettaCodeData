import strformat

proc linearCombo(c: openArray[int]): string =

  for i, n in c:
    if n == 0: continue
    let op = if n < 0:
               if result.len == 0: "-" else: " - "
             else:
               if n > 0 and result.len == 0: "" else: " + "
    let av = abs(n)
    let coeff = if av == 1: "" else: $av & '*'
    result &= fmt"{op}{coeff}e({i + 1})"
  if result.len == 0:
    result = "0"

const Combos = [@[1, 2, 3],
                @[0, 1, 2, 3],
                @[1, 0, 3, 4],
                @[1, 2, 0],
                @[0, 0, 0],
                @[0],
                @[1, 1, 1],
                @[-1, -1, -1],
                @[-1, -2, 0, -3],
                @[-1]]

for c in Combos:
  echo fmt"{($c)[1..^1]:15}  →  {linearCombo(c)}"
