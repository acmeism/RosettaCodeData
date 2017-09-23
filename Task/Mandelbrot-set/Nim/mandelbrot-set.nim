import complex

proc mandelbrot(a: Complex): Complex =
  for i in 0 .. <50:
    result = result * result + a

iterator stepIt(start, step: float, iterations: int): auto =
  for i in 0 .. iterations:
    yield start + float(i) * step

var rows = ""
for y in stepIt(1.0, -0.05, 41):
  for x in stepIt(-2.0, 0.0315, 80):
    if abs(mandelbrot((x,y))) < 2:
      rows.add('*')
    else:
      rows.add(' ')
  rows.add("\n")

echo rows
