import lenientops, math
import grayscale_image

const White = 255

func houghTransform*(img: GrayImage; hx = 460; hy = 360): GrayImage =
  assert not img.isNil
  assert hx > 0 and hy > 0
  assert (hy and 1) == 0, "hy argument must be even"

  result = newGrayImage(hx, hy)
  result.fill(White)

  let rMax = hypot(img.w.toFloat, img.h.toFloat)
  let dr = rMax / (hy / 2)
  let dTh = PI / hx

  for y in 0..<img.h:
    for x in 0..<img.w:
      if img[x, y] == White: continue
      for iTh in 0..<hx:
        let th = dTh * iTh
        let r = x * cos(th) + y * sin(th)
        let iry = hy div 2 - (r / dr).toInt
        if result[iTh, iry] > 0:
          result[iTh, iry] = result[iTh, iry] - 1


when isMainModule:
  import nimPNG
  import bitmap

  const Input = "Pentagon.png"
  const Output = "Hough.png"

  let pngImage = loadPNG24(seq[byte], Input).get()
  let grayImage = newGrayImage(pngImage.width, pngImage.height)

  # Convert to grayscale.
  for i in 0..grayImage.pixels.high:
    grayImage.pixels[i] = Luminance(0.2126 * pngImage.data[3 * i] +
                                    0.7152 * pngImage.data[3 * i + 1] +
                                    0.0722 * pngImage.data[3 * i + 2] + 0.5)

  # Apply Hough transform and convert to an RGB image.
  let houghImage = grayImage.houghTransform().toImage()

  # Save into a PNG file.
  # As nimPNG expects a sequence of bytes, not a sequence of colors, we have to make a copy.
  var data = newSeqOfCap[byte](houghImage.pixels.len * 3)
  for color in houghImage.pixels:
    data.add([color.r, color.g, color.b])
  discard savePNG24(Output, data, houghImage.w, houghImage.h)
