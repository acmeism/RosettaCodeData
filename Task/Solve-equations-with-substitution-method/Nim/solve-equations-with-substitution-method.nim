type Equation = tuple[cx, cy, cr: float]   # cx.x + cy.y = cr.

func getCrossingPoint(firstEquation, secondEquation: Equation): tuple[x, y: float] =
  let (x1, y1, r1) = firstEquation
  let (x2, y2, r2) = secondEquation
  let temp = (x1, -y1, r1)
  result.y = ((temp[0] * r2) - (x2 * temp[2])) / ((x2 * temp[1]) + (temp[0] * y2))
  result.x = (r1 - (y1 * result.y)) / x1

when isMainModule:
  let firstEquation: Equation = (3, 1, -1)
  let secondEquation: Equation = (2, -3, -19)
  let (x, y) = getCrossingPoint(firstEquation, secondEquation)
  echo "x = ", x
  echo "y = ", y
