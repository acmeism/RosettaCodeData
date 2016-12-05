proc ha(a, b): auto = [a xor b, a and b] # sum, carry

proc fa(a, b, ci): auto =
  let a = ha(ci, a)
  let b = ha(a[0], b)
  [b[0], a[1] or b[1]] # sum, carry

proc fa4(a,b): array[5, bool] =
  var co,s: array[4, bool]
  for i in 0..3:
    let r = fa(a[i], b[i], if i > 0: co[i-1] else: false)
    s[i] = r[0]
    co[i] = r[1]
  result[0..3] = s
  result[4] = co[3]

proc int2bus(n): array[4, bool] =
  var n = n
  for i in 0..result.high:
    result[i] = (n and 1) == 1
    n = n shr 1

proc bus2int(b): int =
  for i,x in b:
    result += (if x: 1 else: 0) shl i

for a in 0..7:
  for b in 0..7:
    assert a + b == bus2int fa4(int2bus(a), int2bus(b))
