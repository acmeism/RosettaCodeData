import strformat
import imageman

var img50, img100: Image[ColorRGBU]
try:
  img50 = loadImage[ColorRGBU]("Lenna50.jpg")
  img100 = loadImage[ColorRGBU]("Lenna100.jpg")
except IOError:
  echo getCurrentExceptionMsg()
  quit QuitFailure

let width = img50.width
let height = img50.height
if img100.width != width or img100.height != height:
  quit "Images have different sizes.", QuitFailure

var sum = 0
for x in 0..<height:
  for y in 0..<width:
    let color1 = img50[x, y]
    let color2 = img100[x, y]
    for i in 0..2:
      sum += abs(color1[i].int - color2[i].int)

echo &"Image difference: {sum * 100 / (width * height * 3 * 255):.4f} %"
