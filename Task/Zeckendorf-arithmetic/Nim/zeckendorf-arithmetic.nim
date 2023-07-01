type Zeckendorf = object
  dVal: Natural
  dLen: Natural

const
  Dig = ["00", "01", "10"]
  Dig1 = ["", "1", "10"]

# Forward references.
func b(z: var Zeckendorf; pos: Natural)
func inc(z: var Zeckendorf)


func a(z: var Zeckendorf; n: Natural) =
  var i = n
  while true:

    if z.dLen < i: z.dLen = i
    let j = z.dVal shr (i * 2) and 3

    case j
    of 0, 1:
      return
    of 2:
      if (z.dVal shr ((i + 1) * 2) and 1) != 1: return
      z.dVal += 1 shl (i * 2 + 1)
      return
    of 3:
      z.dVal = z.dVal and not (3 shl (i * 2))
      z.b((i + 1) * 2)
    else:
        assert(false)

    inc i


func b(z: var Zeckendorf; pos: Natural) =
  if pos == 0:
    inc z
    return

  if (z.dVal shr pos and 1) == 0:
    z.dVal += 1 shl pos
    z.a(pos div 2)
    if pos > 1: z.a(pos div 2 - 1)
  else:
    z.dVal = z.dVal and not(1 shl pos)
    z.b(pos + 1)
    z.b(pos - (if pos > 1: 2 else: 1))


func c(z: var Zeckendorf; pos: Natural) =
  if (z.dVal shr pos and 1) == 1:
    z.dVal = z.dVal and not(1 shl pos)
    return

  z.c(pos + 1)
  if pos > 0:
    z.b(pos - 1)
  else:
    inc z


func initZeckendorf(s = "0"): Zeckendorf =
  var q = 1
  var i = s.high
  result.dLen = i div 2
  while i >= 0:
    result.dVal += (ord(s[i]) - ord('0')) * q
    q *= 2
    dec i


func inc(z: var Zeckendorf) =
  inc z.dVal
  z.a(0)


func `+=`(z1: var Zeckendorf; z2: Zeckendorf) =
  for gn in 0 .. (2 * z2.dLen + 1):
    if (z2.dVal shr gn and 1) == 1:
      z1.b(gn)


func `-=`(z1: var Zeckendorf; z2: Zeckendorf) =
  for gn in 0 .. (2 * z2.dLen + 1):
    if (z2.dVal shr gn and 1) == 1:
      z1.c(gn)

  while z1.dLen > 0 and (z1.dVal shr (z1.dLen * 2) and 3) == 0:
    dec z1.dLen


func `*=`(z1: var Zeckendorf; z2: Zeckendorf) =
  var na, nb = z2
  var nr: Zeckendorf
  for i in 0 .. (z1.dLen + 1) * 2:
    if (z1.dVal shr i and 1) > 0: nr += nb
    let nt = nb
    nb += na
    na = nt
  z1 = nr

func`$`(z: var Zeckendorf): string =
  if z.dVal == 0: return "0"
  result.add Dig1[z.dVal shr (z.dLen * 2) and 3]
  for i in countdown(z.dLen - 1, 0):
    result.add Dig[z.dVal shr (i * 2) and 3]

when isMainModule:

  var g: Zeckendorf

  echo "Addition:"
  g = initZeckendorf("10")
  g += initZeckendorf("10")
  echo g
  g += initZeckendorf("10")
  echo g
  g += initZeckendorf("1001")
  echo g
  g += initZeckendorf("1000")
  echo g
  g += initZeckendorf("10101")
  echo g


  echo "\nSubtraction:"
  g = initZeckendorf("1000")
  g -= initZeckendorf("101")
  echo g
  g = initZeckendorf("10101010")
  g -= initZeckendorf("1010101")
  echo g

  echo "\nMultiplication:"
  g = initZeckendorf("1001")
  g *= initZeckendorf("101")
  echo g
  g = initZeckendorf("101010")
  g += initZeckendorf("101")
  echo g
