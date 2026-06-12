import std/[math, random]
import cairo

const

  Width = 1000
  Height = 800

  HR = 1.3247     # Harriss ratio.
  HR2 = HR * HR
  HR3 = HR2 * HR
  HR4 = HR2 * HR2
  HR5 = HR4 * HR
  HR6 = HR3 * HR3
  HR8 = HR4 * HR4

  ShowLines = false   # Set to true to show construction lines.varargs

  White = (1.0, 1.0, 1.0)
  Black = (0.0, 0.0, 0.0)
  Red = (1.0, 0.0, 0.0)
  Green = (0.0, 1.0, 0.0)
  Blue = (0.0, 0.0, 1.0)
  Yellow = (1.0, 1.0, 0.0)
  Orange = (1.0, 165 / 255, 0.0)
  DarkGray = (169 / 255, 169 / 255, 169 / 255)


type Heading {.pure.} = enum SN, EW, NS, WE


proc setColor(context: ptr Context; color: (float, float, float)) =
  context.setSourceRgb(color[0], color[1], color[2])


proc drawArcSegment(context: ptr Context; x, y, angle, length: float;
                    iteration: Natural; lineWidth: float) =

  if iteration == 0: return

  let startAngle = angle + 45
  let endAngle = startAngle + 90
  let xEnd = x + length * cos(angle.degToRad)
  let yEnd = y + length * sin(angle.degToRad)

  var heading: Heading
  if floor(yEnd) < floor(y): heading = SN
  elif floor(xEnd) < floor(x): heading = EW
  elif floor(yEnd) > floor(y): heading = NS
  elif floor(xEnd) > floor(x): heading = WE
  else: raise newException(ValueError, "Invalid values.")

  if ShowLines:
    context.setColor(Black)
    context.setLineWidth(1)
    context.moveTo(x, y)
    context.lineTo(xEnd, yEnd)
    context.stroke()

  let radius = 0.70710678 * length

  let (cx, cy, arcColor) = case heading
    of SN: (x - length / 2, y - length / 2, if rand(1) == 0: Yellow else: Green)
    of EW: (x - length / 2, y + length / 2, Red)
    of NS: (x + length / 2, y + length / 2, Blue)
    of WE: (x + length / 2, y - length / 2, if rand(1) == 0: Orange else: Black)

  context.setColor(arcColor)
  context.setLineWidth(lineWidth)
  context.arc(cx, cy, radius, degToRad(startAngle), degToRad(endAngle))
  context.stroke()
  context.drawArcSegment(xEnd, yEnd, angle - 90, length / HR, iteration - 1, lineWidth)


proc drawSpiral(surface: ptr Surface) =

  let context = create(surface)

  # Fill background.
  context.setColor(if ShowLines: White else: DarkGray)
  context.paint()

  var
    h = 600.0
    sx = (Width / 2 + 80)     # Starting x.
    sy = (Height - 140.0)     # Starting y.
    il = h / HR2              # Initial length.

  context.drawArcSegment(sx + il / HR,  sy - (il + il / HR2), 0, il / HR4, 4, 6)
  context.drawArcSegment(sx + il / HR4, sy - (il + il / HR2), 270, il / HR5, 3, 6)
  context.drawArcSegment(sx - (il / HR + il / HR3), sy - (il + il / HR2), 270, il / HR5, 3, 6)
  context.drawArcSegment(sx - (il / HR + il / HR3), sy - il / HR8, 180, il / HR6, 2, 6)
  context.drawArcSegment(sx - il / HR4, sy - il / HR3, -270, il / HR4, 3, 8)
  context.drawArcSegment(sx - il / HR4, sy - il / HR, 0, il / HR5, 2, 8)
  context.drawArcSegment(sx - il / HR, sy - il, 270, il / HR2, 5, 12)
  context.drawArcSegment(sx - il / HR, sy - il / HR3, 180, il / HR3, 4, 12)
  context.drawArcSegment(sx, sy - il, 0, il / HR, 6, 16)
  context.drawArcSegment(sx, sy, -90, il, 7, 16)

  context.destroy()


randomize()
let surface = imageSurfaceCreate(FormatRgb24, Width, Height)
surface.drawSpiral()
if surface.writeToPng("harriss.png") != StatusSuccess:
  quit "Error while saving file.", QuitFailure
surface.destroy()
