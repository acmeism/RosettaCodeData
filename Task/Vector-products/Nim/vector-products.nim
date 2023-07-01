import strformat, strutils

type Vector3 = array[1..3, float]

proc `$`(a: Vector3): string =
  result = "("
  for x in a:
    result.addSep(", ", 1)
    result.add &"{x}"
  result.add ')'

proc cross(a, b: Vector3): Vector3 =
  result = [a[2]*b[3] - a[3]*b[2], a[3]*b[1] - a[1]*b[3], a[1]*b[2] - a[2]*b[1]]

proc dot(a, b: Vector3): float =
  for i in a.low..a.high:
    result += a[i] * b[i]

proc scalarTriple(a, b, c: Vector3): float = a.dot(b.cross(c))

proc vectorTriple(a, b, c: Vector3): Vector3 = a.cross(b.cross(c))

let
  a = [3.0, 4.0, 5.0]
  b = [4.0, 3.0, 5.0]
  c = [-5.0, -12.0, -13.0]

echo &"a ⨯ b = {a.cross(b)}"
echo &"a . b = {a.dot(b)}"
echo &"a . (b ⨯ c) = {scalarTriple(a, b, c)}"
echo &"a ⨯ (b ⨯ c) = {vectorTriple(a, b, c)}"
