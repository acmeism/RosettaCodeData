import complex

proc inMandelbrotSet(c: Complex, maxEscapeIterations = 50): bool =
  result = true; var z: Complex
  for i in 0..maxEscapeIterations:
    z = z * z + c
    if abs2(z) > 4: return false

iterator steps(start, step: float, numPixels: int): float =
  for i in 0..numPixels:
    yield start + i.float * step

proc mandelbrotImage(yStart, yStep, xStart, xStep: float, height, width: int): string =
  for y in steps(yStart, yStep, height):
    for x in steps(xStart, xStep, width):
      result.add(if complex(x, y).inMandelbrotSet: '*'
                 else: ' ')
    result.add('\n')

echo mandelbrotImage(1.0, -0.05, -2.0, 0.0315, 40, 80)
