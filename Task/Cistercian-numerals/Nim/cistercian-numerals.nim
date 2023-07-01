const Size = 15

type Canvas = array[Size, array[Size, char]]


func horizontal(canvas: var Canvas; col1, col2, row: Natural) =
  for col in col1..col2:
    canvas[row][col] = 'x'


func vertical(canvas: var Canvas; row1, row2, col: Natural) =
  for row in row1..row2:
    canvas[row][col] = 'x'


func diagd(canvas: var Canvas; col1, col2, row: Natural) =
  for col in col1..col2:
    canvas[row + col - col1][col] = 'x'


func diagu(canvas: var Canvas; col1, col2, row: Natural) =
  for col in col1..col2:
    canvas[row - col + col1][col] = 'x'


func drawPart(canvas: var Canvas; value: Natural) =

  case value
  of 1:
    canvas.horizontal(6, 10, 0)
  of 2:
    canvas.horizontal(6, 10, 4)
  of 3:
    canvas.diagd(6, 10, 0)
  of 4:
    canvas.diagu(6, 10, 4)
  of 5:
    canvas.drawPart(1)
    canvas.drawPart(4)
  of 6:
    canvas.vertical(0, 4, 10)
  of 7:
    canvas.drawPart(1)
    canvas.drawPart(6)
  of 8:
    canvas.drawPart(2)
    canvas.drawPart(6)
  of 9:
    canvas.drawPart(1)
    canvas.drawPart(8)
  of 10:
    canvas.horizontal(0, 4, 0)
  of 20:
    canvas.horizontal(0, 4, 4)
  of 30:
    canvas.diagu(0, 4, 4)
  of 40:
    canvas.diagd(0, 4, 0)
  of 50:
    canvas.drawPart(10)
    canvas.drawPart(40)
  of 60:
    canvas.vertical(0, 4, 0)
  of 70:
    canvas.drawPart(10)
    canvas.drawPart(60)
  of 80:
    canvas.drawPart(20)
    canvas.drawPart(60)
  of 90:
    canvas.drawPart(10)
    canvas.drawPart(80)
  of 100:
    canvas.horizontal(6, 10, 14)
  of 200:
    canvas.horizontal(6, 10, 10)
  of 300:
    canvas.diagu(6, 10, 14)
  of 400:
    canvas.diagd(6, 10, 10)
  of 500:
    canvas.drawPart(100)
    canvas.drawPart(400)
  of 600:
    canvas.vertical(10, 14, 10)
  of 700:
    canvas.drawPart(100)
    canvas.drawPart(600)
  of 800:
    canvas.drawPart(200)
    canvas.drawPart(600)
  of 900:
    canvas.drawPart(100)
    canvas.drawPart(800)
  of 1000:
    canvas.horizontal(0, 4, 14)
  of 2000:
    canvas.horizontal(0, 4, 10)
  of 3000:
    canvas.diagd(0, 4, 10)
  of 4000:
    canvas.diagu(0, 4, 14)
  of 5000:
    canvas.drawPart(1000)
    canvas.drawPart(4000)
  of 6000:
    canvas.vertical(10, 14, 0)
  of 7000:
    canvas.drawPart(1000)
    canvas.drawPart(6000)
  of 8000:
    canvas.drawPart(2000)
    canvas.drawPart(6000)
  of 9000:
    canvas.drawPart(1000)
    canvas.drawPart(8000)
  else:
    raise newException(ValueError, "wrong value for 'drawPart'")


func draw(canvas: var Canvas; value: Natural) =

  var val = value
  let thousands = val div 1000
  val = val mod 1000
  let hundreds = val div 100
  val = val mod 100
  let tens = val div 10
  let ones = val mod 10

  if thousands != 0:
    canvas.drawPart(1000 * thousands)
  if hundreds != 0:
    canvas.drawPart(100 * hundreds)
  if tens != 0:
    canvas.drawPart(10 * tens)
  if ones != 0:
    canvas.drawPart(ones)


func cistercian(n: Natural): Canvas =
  for row in result.mitems:
    for cell in row.mitems: cell = ' '
    row[5] = 'x'
  result.draw(n)


proc `$`(canvas: Canvas): string =
  for row in canvas:
    for cell in row:
      result.add cell
    result.add '\n'


when isMainModule:

  for number in [0, 1, 20, 300, 4000, 5555, 6789, 9999]:
    echo number, ':'
    echo cistercian(number)
