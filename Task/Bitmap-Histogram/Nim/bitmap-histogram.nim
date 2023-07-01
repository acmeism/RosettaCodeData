import bitmap
import grayscale_image

type Histogram = array[Luminance, Natural]

#---------------------------------------------------------------------------------------------------

func histogram*(img: GrayImage): Histogram =
  ## Build and return gray scale image histogram.
  for lum in img.pixels:
    inc result[lum]

#---------------------------------------------------------------------------------------------------

func median*(hist: Histogram): Luminance =
  # Return the median luminance of a histogram.
  var
    inf = byte(0)
    sup = Luminance.high
    infCount, supCount = 0

  while inf != sup:
    if infCount < supCount:
      inc infCount, hist[inf]
      inc inf
    else:
      inc supCount, hist[sup]
      dec sup

  result = inf

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import ppm_read, ppm_write

  # Read an image.
  let image = readPPM("house.ppm")

  # Build its histogram and find the median luminance.
  let grayImage = image.toGrayImage
  let hist = grayImage.histogram()
  let m = hist.median()
  echo "Median luminance: ", m

  # Convert to black and white.
  for pt in image.indices:
    image[pt.x, pt.y] = if grayImage[pt.x, pt.y] < m: Black else: White

  # Save image as a PPM file.
  image.writePPM("house_bw.ppm")
