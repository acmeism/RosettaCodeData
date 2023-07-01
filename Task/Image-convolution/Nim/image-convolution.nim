import math, lenientops, strutils
import nimPNG, bitmap, grayscale_image

type ConvolutionFilter = object
  kernel: seq[seq[float]]
  divisor: float
  offset: float
  name: string

func convolve[T: Image|GrayImage](img: T; filter: ConvolutionFilter): T =

  assert not img.isNil
  assert filter.divisor.classify != fcNan and filter.offset.classify != fcNan
  assert filter.divisor != 0
  assert filter.kernel.len > 0 and filter.kernel[0].len > 0
  for row in filter.kernel:
    assert row.len == filter.kernel[0].len
  assert filter.kernel.len mod 2 == 1
  assert filter.kernel[0].len mod 2 == 1
  assert img.h >= filter.kernel.len
  assert img.w >= filter.kernel[0].len

  let knx2 = filter.kernel[0].len div 2
  let kny2 = filter.kernel.len div 2

  when T is Image:
    result = newImage(img.w, img.h)
  else:
    result = newGrayImage(img.w, img.h)

  for y in kny2..<(img.h - kny2):
    for x in knx2..<(img.w - knx2):
      when T is Image:
        var total: array[3, float]
      else:
        var total: float
      for sy, kRow in filter.kernel:
        for sx, k in kRow:
          let p = img[x + sx - knx2, y + sy - kny2]
          when T is Image:
            total[0] += p.r * k
            total[1] += p.g * k
            total[2] += p.b * k
          else:
            total += p * k

      let d = filter.divisor
      let off = filter.offset * Luminance.high
      when T is Image:
        result[x, y] = color(min(max(total[0] / d + off, Luminance.low.float),
                                Luminance.high.float).toInt,
                            min(max(total[1] / d + off, Luminance.low.float),
                                Luminance.high.float).toInt,
                            min(max(total[2] / d + off, Luminance.low.float),
                                Luminance.high.float).toInt)
      else:
        result[x, y] = Luminance(min(max(total / d + off, Luminance.low.float),
                                     Luminance.high.float).toInt)

const
  Input = "lena.png"
  Output1 = "lena_$1.png"
  Output2 = "lena_gray_$1.png"

const Filters = [ConvolutionFilter(kernel: @[@[-2.0, -1.0, 0.0],
                                             @[-1.0,  1.0, 1.0],
                                             @[ 0.0,  1.0, 2.0]],
                                   divisor: 1.0, offset: 0.0, name: "Emboss"),

                 ConvolutionFilter(kernel: @[@[-1.0, -1.0, -1.0],
                                             @[-1.0,  9.0, -1.0],
                                             @[-1.0, -1.0, -1.0]],
                                   divisor: 1.0, offset: 0.0, name: "Sharpen"),

                 ConvolutionFilter(kernel: @[@[-1.0, -2.0, -1.0],
                                             @[ 0.0,  0.0,  0.0],
                                             @[ 1.0,  2.0,  1.0]],
                                   divisor: 1.0, offset: 0.5, name: "Sobel_emboss"),

                 ConvolutionFilter(kernel: @[@[1.0, 1.0, 1.0],
                                             @[1.0, 1.0, 1.0],
                                             @[1.0, 1.0, 1.0]],
                                   divisor: 9.0, offset: 0.0, name: "Box_blur"),

                 ConvolutionFilter(kernel: @[@[1.0,  4.0,  7.0,  4.0, 1.0],
                                             @[4.0, 16.0, 26.0, 16.0, 4.0],
                                             @[7.0, 26.0, 41.0, 26.0, 7.0],
                                             @[4.0, 16.0, 26.0, 16.0, 4.0],
                                             @[1.0,  4.0,  7.0,  4.0, 1.0]],
                                   divisor: 273.0, offset: 0.0, name: "Gaussian_blur")]

let pngImage = loadPNG24(seq[byte], Input).get()

# Convert to an image managed by the "bitmap" module.
let img = newImage(pngImage.width, pngImage.height)
for i in 0..img.pixels.high:
  img.pixels[i] = color(pngImage.data[3 * i],
                        pngImage.data[3 * i + 1],
                        pngImage.data[3 * i + 2])

for filter in Filters:
  let result = img.convolve(filter)
  var data = newSeqOfCap[byte](result.pixels.len * 3)
  for color in result.pixels:
    data.add([color.r, color.g, color.b])
  let output = Output1.format(filter.name)
  if savePNG24(output, data, result.w, result.h).isOk:
    echo "Saved: ", output

let grayImg = img.toGrayImage()
for filter in Filters:
  let result = grayImg.convolve(filter).toImage()
  var data = newSeqOfCap[byte](result.pixels.len * 3)
  for color in result.pixels:
    data.add([color.r, color.g, color.b])
  let output = Output2.format(filter.name)
  if savePNG24(output, data, result.w, result.h).isOk:
    echo "Saved: ", output
