import bitmap
import ppm_write
import osproc

# Build an image.
var image = newImage(100, 50)
image.fill(color(255, 0, 0))
for row in 10..20:
  for col in 0..<image.w:
    image[col, row] = color(0, 255, 0)
for row in 30..40:
  for col in 0..<image.w:
    image[col, row] = color(0, 0, 255)

# Launch ImageMagick "convert".
# Input is taken from stdin and result written in "output1.jpeg".
var p = startProcess("convert", args = ["ppm:-", "output1.jpeg"], options = {poUsePath})
var stream = p.inputStream()
image.writePPM(stream)
p.close()

# Launch Netpbm "pnmtojpeg".
# Input is taken from stdin and output sent to "output2.jpeg".
p = startProcess("pnmtojpeg >output2.jpeg", options = {poUsePath, poEvalCommand})
stream = p.inputStream()
image.writePPM(stream)
p.close()
