import options,math,sugar,strformat
template checkAndWrap(x:float,body:typed): untyped =
  if x.classify in {fcNormal,fcZero,fcNegZero}:
    some(body)
  else:
    none(typeof(body))
func reciprocal(x:float):Option[float] =
  let res = 1 / x
  res.checkAndWrap(res)
func log(x:float):Option[float] =
  let res = ln(x)
  res.checkAndWrap(res)
func format(x:float):Option[string] =
  x.checkAndWrap(&"{x:.2f}")

#our bind function:
func `-->`[T,U](input:Option[T], f: T->Option[U]):Option[U] =
  if input.isSome:
    f(input.get)
  else:
    none(U)

when isMainModule:
  for i in [0.9,0.0,-0.9,3.0]:
    echo some(i) --> reciprocal --> log --> format
