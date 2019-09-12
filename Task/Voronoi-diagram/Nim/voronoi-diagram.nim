from sequtils import newSeqWith
from random import rand, randomize
from times import now
import libgd

const
  img_width  = 400
  img_height = 300
  nSites = 20

proc dot(x, y: int): int = x * x + y * y

proc generateVoronoi(img: gdImagePtr) =

  randomize(cast[int64](now()))

  # random sites
  let sx = newSeqWith(nSites, rand(img_width))
  let sy = newSeqWith(nSites, rand(img_height))

  # generate a random color for each site
  let sc = newSeqWith(nSites, img.setColor(rand(255), rand(255), rand(255)))

  # generate diagram by coloring each pixel with color of nearest site
  for x in 0 ..< img_width:
    for y in 0 ..< img_height:
      var dMin = dot(img_width, img_height)
      var sMin: int
      for s in 0 ..< nSites:
        if (let d = dot(sx[s] - x, sy[s] - y); d) < dMin:
          (sMin, dMin) = (s, d)

      img.setPixel(point=[x, y], color=sc[sMin])

  # mark each site with a black box
  let black = img.setColor(0x000000)
  for s in 0 ..< nSites:
    img.drawRectangle(
      startCorner=[sx[s] - 2, sy[s] - 2],
      endCorner=[sx[s] + 2, sy[s] + 2],
      color=black,
      fill=true)

proc main() =

  withGd imageCreate(img_width, img_height, trueColor=true) as img:
    img.generateVoronoi()

    let png_out = open("outputs/voronoi_diagram.png", fmWrite)
    img.writePng(png_out)
    png_out.close()

main()
