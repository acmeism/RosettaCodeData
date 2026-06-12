import imageman

func lerp(s, e, t: float): float =
  s + (e - s) * t

func blerp(c00, c10, c01, c11, tx, ty: float): float =
  lerp(lerp(c00, c10, tx), lerp(c01, c11, tx), ty)

func scale(img: Image; scaleX, scaleY: float): Image =
  let newWidth = (img.width.toFloat * scaleX).toInt
  let newHeight = (img.height.toFloat * scaleY).toInt
  result = initImage[ColorRGBU](newWidth, newHeight)
  for x in 0..<newWidth:
    for y in 0..<newHeight:
      let gx = x * (img.width  - 1) / newWidth
      let gy = y * (img.height - 1) / newHeight
      let gxi = gx.int
      let gyi = gy.int
      let gxf = gx - float(gxi)
      let gyf = gy - float(gyi)
      let c00 = img[gxi, gyi]
      let c10 = img[gxi + 1, gyi]
      let c01 = img[gxi, gyi + 1]
      let c11 = img[gxi + 1, gyi + 1]
      let red   = blerp(float(c00[0]), float(c10[0]), float(c01[0]), float(c11[0]), gxf, gyf).toInt
      let green = blerp(float(c00[1]), float(c10[1]), float(c01[1]), float(c11[1]), gxf, gyf).toInt
      let blue  = blerp(float(c00[2]), float(c10[2]), float(c01[2]), float(c11[2]), gxf, gyf).toInt
      result[x, y] = ColorRGBU([byte(red), byte(green), byte(blue)])

when isMainModule:

  let image = loadImage[ColorRGBU]("Lenna100.jpg")
  let newImage = image.scale(1.6, 1.6)
  newImage.saveJPEG("Lenna100_bilinear.jpg")
