import algorithm
import imageman

func luminance(color: ColorRGBF64): float =
  0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b

proc applyMedianFilter(img: var Image; windowWidth, windowHeight: Positive) =
  var window = newSeq[ColorRGBF64](windowWidth * windowHeight)
  let edgeX = windowWidth div 2
  let edgeY = windowHeight div 2

  for x in edgeX..<(img.width - edgeX):
    for y in edgeY..<(img.height - edgeY):
      var i = 0
      for fx in 0..<windowWidth:
        for fy in 0..<windowHeight:
          window[i] = img[x + fx - edgeX, y + fy - edgeY]
          inc i
      window = window.sortedByIt(luminance(it))
      img[x, y] = window[windowWidth * windowHeight div 2]


when isMainModule:
  let fullImage = loadImage[ColorRGBF64]("Medianfilterp.png")
  # Extract left part of the image.
  var image = fullImage[0..<(fullImage.width div 2), 0..<fullImage.height]
  image.applyMedianFilter(3, 3)
  savePNG(image, "Medianfilterp_3x3.png")
