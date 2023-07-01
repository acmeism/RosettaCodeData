import math, strformat

const B = 7

type Point = tuple[x, y: float]

#---------------------------------------------------------------------------------------------------

template zero(): Point =
  (Inf, Inf)

#---------------------------------------------------------------------------------------------------

func isZero(pt: Point): bool {.inline.} =
  pt.x > 1e20 or pt.x < -1e20

#---------------------------------------------------------------------------------------------------

func `-`(pt: Point): Point {.inline.} =
  (pt.x, -pt.y)

#---------------------------------------------------------------------------------------------------

func double(pt: Point): Point =

  if pt.isZero: return pt

  let t = (3 * pt.x * pt.x) / (2 * pt.y)
  result.x = t * t - 2 * pt.x
  result.y = t * (pt.x - result.x) - pt.y

#---------------------------------------------------------------------------------------------------

func `+`(pt1, pt2: Point): Point =

  if pt1.x == pt2.x and pt1.y == pt2.y: return double(pt1)
  if pt1.isZero: return pt2
  if pt2.isZero: return pt1

  let t = (pt2.y - pt1.y) / (pt2.x - pt1.x)
  result.x = t * t - pt1.x - pt2.x
  result.y = t * (pt1.x - result.x) - pt1.y

#---------------------------------------------------------------------------------------------------

func `*`(pt: Point; n: int): Point =

  result = zero()
  var pt = pt
  var i = 1

  while i <= n:
    if (i and n) != 0:
      result = result + pt
    pt = double(pt)
    i = i shl 1

#---------------------------------------------------------------------------------------------------

func `$`(pt: Point): string =
  if pt.isZero: "Zero" else: fmt"({pt.x:.3f}, {pt.y:.3f})"

#---------------------------------------------------------------------------------------------------

func fromY(y: float): Point {.inline.} =
  (cbrt(y * y - B), y)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  let a = fromY(1)
  let b = fromY(2)

  echo "a = ", a
  echo "b = ", b
  let c = a + b
  echo "c = a + b = ", c
  let d = -c
  echo "d = -c = ", d
  echo "c + d = ", c + d
  echo "a + b + d = ", a + b + d
  echo "a * 12345 = ", a * 12345
