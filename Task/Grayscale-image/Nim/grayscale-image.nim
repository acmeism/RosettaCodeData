import bitmap
import lenientops

type

  GrayImage* = object
    w*, h*: Index
    pixels*: seq[Luminance]

proc newGrayImage*(width, height: int): GrayImage =
  ## Create a gray image with given width and height.
  new(result)
  result.w = width
  result.h = height
  result.pixels.setLen(width * height)

iterator indices*(img: GrayImage): Point =
  ## Yield the pixels coordinates as tuples.
  for y in 0 ..< img.h:
    for x in 0 ..< img.w:
      yield (x, y)

proc `[]`*(img: GrayImage; x, y: int): Luminance =
  ## Get a pixel luminance value.
  img.pixels[y * img.w + x]

proc `[]=`*(img: GrayImage; x, y: int; lum: Luminance) =
  ## Set a pixel luminance to given value.
  img.pixels[y * img.w + x] = lum

proc fill*(img: GrayImage; lum: Luminance) =
  ## Set the pixels to a given luminance.
  for x, y in img.indices:
    img[x, y] = lum

func toGrayLuminance(color: Color): Luminance =
  ## Compute the luminance from RGB value.
  Luminance(0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b + 0.5)

func toGrayImage*(img: Image): GrayImage =
  ##
  result = newGrayImage(img.w, img.h)
  for pt in img.indices:
    result[pt.x, pt.y] = img[pt.x, pt.y].toGrayLuminance()

func toImage*(img: GrayImage): Image =
  result = newImage(img.w, img.h)
  for pt in img.indices:
    let lum = img[pt.x, pt.y]
    result[pt.x, pt.y] = (lum, lum, lum)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import ppm_write

  # Create a RGB image.
  var image = newImage(100, 50)
  image.fill(color(128, 128, 128))
  for row in 10..20:
    for col in 0..<image.w:
      image[col, row] = color(0, 255, 0)
  for row in 30..40:
    for col in 0..<image.w:
      image[col, row] = color(0, 0, 255)

  # Convert it to grayscale.
  var grayImage = image.toGrayImage()

  # Convert it back to RGB in order to save it in PPM format using the available procedure.
  var convertedImage = grayImage.toImage()
  convertedImage.writePPM("output_gray.ppm")
