proc deconv(g, f: openArray[float]): seq[float] =
  var h: seq[float] = newSeq[float](len(g) - len(f) + 1)
  for n in 0..<len(h):
    h[n] = g[n]
    var lower: int
    if n >= len(f):
      lower = n - len(f) + 1
    for i in lower..<n:
      h[n] -= h[i] * f[n - i]
    h[n] /= f[0]
  h

let h = [-8'f64, -9, -3, -1, -6, 7]
let f = [-3'f64, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1]
let g = [24'f64, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96,
         96, 31, 55, 36, 29, -43, -7]
echo $h
echo $deconv(g, f)
echo $f
echo $deconv(g, h)
