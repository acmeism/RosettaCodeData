import math, strformat

const M = [uint64 1, 3, 5, 7, 11]

template isqrt(n: uint64): uint64 = uint64(sqrt(float(n)))
template isEven(n: uint64): bool = (n and 1) == 0

proc squfof(n: uint64): uint64 =

  if n.isEven: return 2
  var h = uint64(sqrt(float(n)) + 0.5)
  if h * h == n: return h

  for m in M:
    if m > 1 and (n mod m == 0): return m
    # Check overflow m * n.
    if n > uint64.high div m: break
    let mn = m * n
    var r = isqrt(mn)
    if r * r > mn: dec r
    let rn = r

    # Principal form.
    var b = r
    var a = 1u64
    h = (rn + b) div a * a - b
    var c = (mn - h * h) div a

    for i in 2..<(4 * isqrt(2 * r)):
      # Search principal cycle.
      swap a, c
      var q = (rn + b) div a
      let t = b
      b = q * a - b
      c += q * (t - b)

      if i.isEven:
        r = uint64(sqrt(float(c)) + 0.5)
        if r * r == c: # Square form found?

          # Inverse square root.
          q = (rn - b) div r
          var v = q * r + b
          var w = (mn - v * v) div r

          # Search ambiguous cycle.
          var u = r
          while true:
            swap w, u
            r = v
            q = (rn + v) div u
            v = q * u - v
            if v == r: break
            w += q * (r - v)

          # Symmetry point.
          h = gcd(n, u)
          if h != 1: return h

  result = 1

const Data = [2501u64,
              12851u64,
              13289u64,
              75301u64,
              120787u64,
              967009u64,
              997417u64,
              7091569u64,
              13290059u64,
              42854447u64,
              223553581u64,
              2027651281u64,
              11111111111u64,
              100895598169u64,
              1002742628021u64,
              60012462237239u64,
              287129523414791u64,
              9007199254740931u64,
              11111111111111111u64,
              314159265358979323u64,
              384307168202281507u64,
              419244183493398773u64,
              658812288346769681u64,
              922337203685477563u64,
              1000000000000000127u64,
              1152921505680588799u64,
              1537228672809128917u64,
              4611686018427387877u64]

echo "N                      f          N/f"
echo "======================================"
for n in Data:
  let f = squfof(n)
  let res = if f == 1: "fail" else: &"{f:<10} {n div f}"
  echo &"{n:<22} {res}"
