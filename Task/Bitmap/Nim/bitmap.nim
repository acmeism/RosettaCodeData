{.experimental.}

import unsigned

type
  Luminance = uint8
  Index = int

  Pixel = tuple
    r, g, b: Luminance

  Image = object
    w, h: Index
    pixels: seq[Pixel]

  Point = tuple
    x, y: Index

proc px(r, g, b): Pixel =
  result.r = r.uint8
  result.g = g.uint8
  result.b = b.uint8

proc img(w, h: int): Image =
  result.w = w
  result.h = h
  result.pixels.newSeq(w * h)

const
  Black = px(  0,   0,   0)
  White = px(255, 255, 255)

iterator indices(img: Image): tuple[x, y: int] =
  for x in 0 .. < img.w:
    for y in 0 .. < img.h:
      yield (x,y)

proc `[]`(img: Image, x, y: int): Pixel =
  img.pixels[y * img.w + x]

proc `[]=`(img: var Image, x, y: int, c: Pixel) =
  img.pixels[y * img.w + x] = c

proc fill(img: var Image, color: Pixel) =
  for x,y in img.indices:
    img[x,y] = color

proc print(img: Image) =
  using stdout
  for x,y in img.indices:
    if img[x,y] == White:
      write ' '
    else:
      write 'H'
    write "\n"

when isMainModule:
  var x = img(64, 64)
  x.fill px(255,255,255)
  x[1,2] = px(255, 0, 0)
  x[3,4] = x[1,2]
