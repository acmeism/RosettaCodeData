import rationals, sequtils, strscans, strutils, sugar

type Fraction = Rational[int]


func argmax(m: seq[seq[Fraction]]; i: int): int =
  var max = -1 // 1
  for x in i..m.high:
    let val = abs(m[x][i])
    if val > max:
      max = val
      result = x


func gauss(m: var seq[seq[Fraction]]): seq[Fraction] =
  let n = m.len
  let p = m[0].len

  for i in 0..<n:
    let k = m.argmax(i)
    swap m[i], m[k]
    let t = 1 / m[i][i]
    for j in (i + 1)..<p:
      m[i][j] *= t
    for j in (i + 1)..<n:
      let t = m[j][i]
      for k in (i + 1)..<p:
        m[j][k] -= t * m[i][k]

  for i in countdown(n - 1, 0):
    for j in 0..<i:
      m[j][^1] -= m[j][i] * m[i][^1]

  result = collect(newSeq, for row in m: row[^1])


func network(n, k0, k1: int; s: string): Fraction =
  var m = newSeqWith(n, repeat(0 // 1, n + 1))
  let resistors = s.split('|')
  for resistor in resistors:
    var a, b, c: int
    if not resistor.scanf("$i $i $i", a, b, c):
      raise newException(ValueError, "Wrong resistor: " & resistor)
    let r: Fraction = 1 // c
    m[a][a] += r
    m[b][b] += r
    if a > 0: m[a][b] -= r
    if b > 0: m[b][a] -= r
  m[k0][k0] = 1 // 1
  m[k1][^1] = 1 // 1
  result = gauss(m)[k1]


assert 10 // 1 == network(7, 0, 1, "0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8")
assert 3 // 2 == network(3*3, 0, 3*3-1, "0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1")
assert 13 // 7 == network(4*4, 0, 4*4-1, "0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1")
assert 180 // 1 == network(4, 0, 3, "0 1 150|0 2 50|1 3 300|2 3 250")
