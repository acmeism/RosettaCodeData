import strutils
import bitmap
import streams

type FormatError = object of CatchableError

# States used to parse the header.
type State = enum waitingMagic, waitingWidth, waitingHeight, waitingColors

#---------------------------------------------------------------------------------------------------

iterator tokens(f: Stream): tuple[value: string, lastInLine: bool] =
  ## Yield the tokens in the header.
  for line in f.lines:
    if not line.startsWith('#'):
      let fields = line.splitWhitespace()
      for i, t in fields:
        yield (t, i == fields.high)

#---------------------------------------------------------------------------------------------------

proc getInt(s: string): int {.inline.} =
  ## Try to parse an int. Raise an exception if not an integer.
  try:
    result = s.parseInt()
  except ValueError:
    raise newException(FormatError, "Invalid value")

#---------------------------------------------------------------------------------------------------

proc header(f: Stream): tuple[width, height: Index] =
  ## Read the header and retrun the image width and height.
  var state = waitingMagic
  for (token, lastInLine) in f.tokens:
    case state
    of waitingMagic:
      if token != "P6":
        raise newException(FormatError, "Invalid file header")
    of waitingWidth:
      result.width = token.getInt()
    of waitingHeight:
      result.height = token.getInt()
    of waitingColors:
      if token.getInt() != 255:
        raise newException(FormatError, "Invalid number of colors")
      if not lastInLine:
        raise newException(FormatError, "Invalid data after number of colors")
      break
    state = succ(state)

#---------------------------------------------------------------------------------------------------

proc readPPM*(f: Stream): Image =
  ## Read a PPM file from a stream into an image.

  let header = f.header()
  result = newImage(header.width, header.height)

  var
    arr: array[256, int8]
    read = f.readData(addr(arr), 256)
    pos = 0

  while read != 0:
    for i in 0 ..< read:
      case pos mod 3
      of 0: result.pixels[pos div 3].r = arr[i].uint8
      of 1: result.pixels[pos div 3].g = arr[i].uint8
      of 2: result.pixels[pos div 3].b = arr[i].uint8
      else: discard
      inc pos

    read = f.readData(addr(arr), 256)

  if pos != 3 * result.w * result.h:
    raise newException(FormatError, "Truncated file")

#---------------------------------------------------------------------------------------------------

proc readPPM*(filename: string): Image =
  ## Load a PPM file into an image.

  var file = openFileStream(filename, fmRead)
  result = file.readPPM()
  file.close()

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  let image = readPPM("output.ppm")
  echo image.h, " ", image.w
