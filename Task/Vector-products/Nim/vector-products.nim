import strutils

type Vector3 = array[1..3, float]

proc `$`(a: Vector3): string =
  result = "["

  for i, x in a:
    if i > a.low:
      result.add ", "
    result.add formatFloat(x, precision = 0)

  result.add "]"

proc `~⨯`(a, b: Vector3): Vector3 =
  result = [a[2]*b[3] - a[3]*b[2], a[3]*b[1] - a[1]*b[3], a[1]*b[2] - a[2]*b[1]]

proc `~•`[T](a, b: T): float =
  for i in a.low..a.high:
    result += a[i] * b[i]

proc scalartrip(a, b, c: Vector3): float = a ~• (b ~⨯ c)

proc vectortrip(a, b, c: Vector3): Vector3 = a ~⨯ (b ~⨯ c)

let
  a = [3.0, 4.0, 5.0]
  b = [4.0, 3.0, 5.0]
  c = [-5.0, -12.0, -13.0]
echo "a ⨯ b = ", a ~⨯ b
echo "a • b = ", (a ~• b).formatFloat(precision = 0)
echo "a . (b ⨯ c) = ", (scalartrip(a, b, c)).formatFloat(precision = 0)
echo "a ⨯ (b ⨯ c) = ", vectortrip(a, b, c)
