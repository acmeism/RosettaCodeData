import imageman

const
  Black = ColorRGBU [byte 0, 0, 0]  # For background.
  Red = ColorRGBU [byte 255, 0, 0]  # For triangle.

proc drawSierpinski(img: var Image; txy: array[1..6, float]; levelsYet: Natural) =
  var nxy: array[1..6, float]
  if levelsYet > 0:
    for i in 1..6:
      let pos = if i < 5: i + 2 else: i - 4
      nxy[i] = (txy[i] + txy[pos]) / 2
    img.drawSierpinski([txy[1], txy[2], nxy[1], nxy[2], nxy[5], nxy[6]], levelsYet - 1)
    img.drawSierpinski([nxy[1], nxy[2], txy[3], txy[4], nxy[3], nxy[4]], levelsyet - 1)
    img.drawSierpinski([nxy[5], nxy[6], nxy[3], nxy[4], txy[5], txy[6]], levelsyet - 1)
  else:
    img.drawPolyline(closed = true, Red,
        (txy[1].toInt, txy[2].toInt), (txy[3].toInt, txy[4].toInt),(txy[5].toInt, txy[6].toInt))

var image = initImage[ColorRGBU](800, 800)
image.fill(Black)
image.drawSierpinski([400.0, 100.0, 700.0, 500.0, 100.0, 500.0], 7)
image.savePNG("sierpinski_triangle.png", compression = 9)
