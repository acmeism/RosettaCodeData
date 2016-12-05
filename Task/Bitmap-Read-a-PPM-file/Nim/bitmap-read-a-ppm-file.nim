import strutils

proc readPPM(f: TFile): Image =
  if f.readLine != "P6":
    raise newException(E_base, "Invalid file format")

  var line = ""
  while f.readLine(line):
    if line[0] != '#':
      break

  var parts = line.split(" ")
  result = img(parseInt parts[0], parseInt parts[1])

  if f.readLine != "255":
    raise newException(E_base, "Invalid file format")

  var
    arr: array[256, int8]
    read = f.readBytes(arr, 0, 256)
    pos = 0

  while read != 0:
    for i in 0 .. < read:
      case pos mod 3
      of 0: result.pixels[pos div 3].r = arr[i].uint8
      of 1: result.pixels[pos div 3].g = arr[i].uint8
      of 2: result.pixels[pos div 3].b = arr[i].uint8
      else: discard

      inc pos

    read = f.readBytes(arr, 0, 256)
