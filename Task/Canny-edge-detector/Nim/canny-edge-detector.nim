import lenientops
import math
import nimPNG

const MaxBrightness = 255

type Pixel = int16    # Used instead of byte to be able to store negative values.

#---------------------------------------------------------------------------------------------------

func convolution*[normalize: static bool](input: seq[Pixel]; output: var seq[Pixel];
                                          kernel: seq[float]; nx, ny, kn: int) =
  ## Do a convolution.
  ## If normalize is true, map pixels to range 0...maxBrightness.

  doAssert kernel.len == kn * kn
  doAssert (kn and 1) == 1
  doAssert nx > kn and ny > kn
  doAssert input.len == output.len

  let khalf = kn div 2

  when normalize:

    var pMin = float.high
    var pMax = -float.high

    for m in khalf..<(nx - khalf):
      for n in khalf..<(ny - khalf):
        var pixel = 0.0
        var c = 0
        for j in -khalf..khalf:
          for i in -khalf..khalf:
            pixel += input[(n - j) * nx + m - i] * kernel[c]
            inc c
        if pixel < pMin:
          pMin = pixel
        if pixel > pMax:
          pMax = pixel

  for m in khalf..<(nx - khalf):
    for n in khalf..<(ny - khalf):
      var pixel = 0.0
      var c = 0
      for j in -khalf..khalf:
        for i in -khalf..khalf:
          pixel += input[(n - j) * nx + m - i] * kernel[c]
          inc c
      when normalize:
        pixel = MaxBrightness * (pixel - pMin) / (pMax - pMin)
      output[n * nx + m] = Pixel(pixel)

#---------------------------------------------------------------------------------------------------

func gaussianFilter(input: seq[Pixel]; output: var seq[Pixel]; nx, ny: int; sigma: float) =
  ## Apply a gaussian filter.

  doAssert input.len == output.len

  let n = 2 * (2 * sigma).toInt + 3
  let mean = floor(n / 2)
  var kernel = newSeq[float](n * n)

  var c = 0
  for i in 0..<n:
    for j in 0..<n:
      kernel[c] = exp(-0.5 * (((i - mean) / sigma) ^ 2 + ((j - mean) / sigma) ^ 2)) /
                  (2 * PI * sigma * sigma)
      inc c

  convolution[true](input, output, kernel, nx, ny, n)

#---------------------------------------------------------------------------------------------------

proc cannyEdgeDetection(input: seq[Pixel];
                        nx, ny: int;
                        tmin, tmax: int;
                        sigma: float): seq[byte] =



  ## Detect edges.
  var output = newSeq[Pixel](input.len)
  gaussianFilter(input, output, nx, ny, sigma)

  const Gx = @[float -1, 0, 1,
                     -2, 0, 2,
                     -1, 0, 1]
  var afterGx = newSeq[Pixel](input.len)
  convolution[false](input, afterGx, Gx, nx, ny, 3)

  const Gy = @[float  1,  2,  1,
                      0,  0,  0,
                     -1, -2, -1]
  var afterGy = newSeq[Pixel](input.len)
  convolution[false](input, afterGy, Gy, nx, ny, 3)

  var g = newSeq[Pixel](input.len)
  for i in 1..(nx - 2):
    for j in 1..(ny - 2):
      let c = i + nx * j
      g[c] = hypot(afterGx[c].toFloat, afterGy[c].toFloat).Pixel

  # Non-maximum suppression: straightforward implementation.
  var nms = newSeq[Pixel](input.len)
  for i in 1..(nx - 2):
    for j in 1..(ny - 2):
      let
        c = i + nx * j
        nn = c - nx
        ss = c + nx
        ww = c + 1
        ee = c - 1
        nw = nn + 1
        ne = nn - 1
        sw = ss + 1
        se = ss - 1
      let aux = arctan2(afterGy[c].toFloat, afterGx[c].toFloat) + PI
      let dir = aux mod PI / PI * 8
      if (((dir <= 1 or dir > 7) and g[c] > g[ee] and g[c] > g[ww]) or      # O°.
          ((dir > 1 and dir <= 3) and g[c] > g[nw] and g[c] > g[se]) or     # 45°.
          ((dir > 3 and dir <= 5) and g[c] > g[nn] and g[c] > g[ss]) or     # 90°.
          ((dir > 5 and dir <= 7) and g[c] > g[ne] and g[c] > g[sw])):      # 135°.
        nms[c] = g[c]
      else:
        nms[c] = 0

  # Tracing edges with hysteresis. Non-recursive implementation.
  var edges = newSeq[int](input.len div 2)
  for item in output.mitems: item = 0
  var c = 0
  for j in 1..(ny - 2):
    for i in 1..(nx - 2):
      inc c

      if nms[c] >= tMax and output[c] == 0:
        # Trace edges.
        output[c] = MaxBrightness
        var nedges = 1
        edges[0] = c

        while nedges > 0:
          dec nedges
          let t = edges[nedges]
          let neighbors = [t - nx,      # nn.
                           t + nx,      # ss.
                           t + 1,       # ww.
                           t - 1,       # ee.
                           t - nx + 1,  # nw.
                           t - nx - 1,  # ne.
                           t + nx + 1,  # sw.
                           t + nx - 1]  # se.

          for n in neighbors:
            if nms[n] >= tMin and output[n] == 0:
              output[n] = MaxBrightness
              edges[nedges] = n
              inc nedges

  # Store the result as a sequence of bytes.
  result = newSeqOfCap[byte](output.len)
  for val in output:
    result.add(byte(val))


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  const
    Input = "Valve.png"
    Output = "Valve_edges.png"

  let pngImage = loadPNG24(seq[byte], Input).get()

  # Convert to grayscale and store luminances as 16 bits signed integers.
  var pixels = newSeq[Pixel](pngImage.width * pngImage.height)
  for i in 0..pixels.high:
    pixels[i] = Pixel(0.2126 * pngImage.data[3 * i] +
                      0.7152 * pngImage.data[3 * i + 1] +
                      0.0722 * pngImage.data[3 * i + 2] + 0.5)

  # Find edges.
  let data = cannyEdgeDetection(pixels, pngImage.width, pngImage.height, 45, 50, 1.0)

  # Save result as a PNG image.
  let status = savePNG(Output, data, LCT_GREY, 8, pngImage.width, pngImage.height)
  if status.isOk:
    echo "File ", Input, " processed. Result is available in file ", Output
  else:
    echo "Error: ", status.error
