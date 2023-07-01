type
  Luminance* = uint8
  Index* = int

  Color* = tuple
    r, g, b: Luminance

  Image* = ref object
    w*, h*: Index
    pixels*: seq[Color]

  Point* = tuple
    x, y: Index

proc color*(r, g, b: SomeInteger): Color =
  ## Build a color value from R, G and B values.
  result.r = r.uint8
  result.g = g.uint8
  result.b = b.uint8

const
  Black* = color(  0,   0,   0)
  White* = color(255, 255, 255)

proc newImage*(width, height: int): Image =
  ## Create an image with given width and height.
  new(result)
  result.w = width
  result.h = height
  result.pixels.setLen(width * height)

iterator indices*(img: Image): Point =
  ## Yield the pixels coordinates as tuples.
  for y in 0 ..< img.h:
    for x in 0 ..< img.w:
      yield (x, y)

proc `[]`*(img: Image; x, y: int): Color =
  ## Get a pixel RGB value.
  img.pixels[y * img.w + x]

proc `[]=`*(img: Image; x, y: int; c: Color) =
  ## Set a pixel RGB value to given color.
  img.pixels[y * img.w + x] = c

proc fill*(img: Image; color: Color) =
  ## Fill the image with a color.
  for x, y in img.indices:
    img[x, y] = color

proc print*(img: Image) =
  ## Output an ASCII representation of the image.
  for x, y in img.indices:
    if x mod img.w == 0:
      stdout.write '\n'
    stdout.write if img[x, y] == White: '.' else: 'H'
  stdout.write '\n'

when isMainModule:
  var img = newImage(100, 20)
  img.fill color(255, 255, 255)
  img[1, 2] = color(255, 0, 0)
  img[3, 4] = img[1, 2]
  img.print
