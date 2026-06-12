import complex, math, sequtils, strutils

func dft(x: openArray[Complex64]): seq[Complex64] =
  let N = x.len
  result.setLen(N)
  for k in 0..<N:
    for n in 0..<N:
      let t = complex64(0, -2 * PI * float(k) * float(n) / float(N))
      result[k] += x[n] * exp(t)


func idft(y: openArray[Complex64]): seq[Complex64] =
  let N = y.len
  result.setLen(N)
  let d = complex64(float(N))
  for n in 0..<N:
    for k in 0..<N:
      let t = complex64(0, 2 * PI * float(k) * float(n) / float(N))
      result[n] += y[k] * exp(t)
    result[n] /= d
    # Clean result[n] to remove very small imaginary values.
    if abs(result[n].im) < 1e-14: result[n].im = 0.0


func `$`(c: Complex64): string =
  result = c.re.formatFloat(ffDecimal, precision = 2)
  if c.im != 0:
    result.add if c.im > 0: "+" else: ""
    result.add c.im.formatFloat(ffDecimal, precision = 2) & 'i'


when isMainModule:

  let x = [float 2, 3, 5, 7, 11].mapIt(complex64(it))
  echo "Original sequence: ", x.join(", ")
  let y = dft(x)
  echo "Discrete Fourier transform: ", y.join(", ")
  echo "Inverse Discrete Fourier Transform: ", idft(y).join(", ")
