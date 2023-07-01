type

  Bools[N: static int] = array[N, bool]
  SumCarry = tuple[sum, carry: bool]

proc ha(a, b: bool): SumCarry = (a xor b, a and b)

proc fa(a, b, ci: bool): SumCarry =
  let a = ha(ci, a)
  let b = ha(a[0], b)
  result = (b[0], a[1] or b[1])

proc fa4(a, b: Bools[4]): Bools[5] =
  var co, s: Bools[4]
  for i in 0..3:
    let r = fa(a[i], b[i], if i > 0: co[i-1] else: false)
    s[i] = r[0]
    co[i] = r[1]
  result[0..3] = s
  result[4] = co[3]

proc int2bus(n: int): Bools[4] =
  var n = n
  for i in 0..result.high:
    result[i] = (n and 1) == 1
    n = n shr 1

proc bus2int(b: Bools): int =
  for i, x in b:
    result += (if x: 1 else: 0) shl i

for a in 0..7:
  for b in 0..7:
    assert a + b == bus2int fa4(int2bus(a), int2bus(b))
