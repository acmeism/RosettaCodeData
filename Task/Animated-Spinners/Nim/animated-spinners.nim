import std/[colors, math]
import gtk2 except update
import gdk2 except PWindow
import glib2, cairo

const
  Width = 350
  Height = 400
  Radius = 50.0
  Cx = (Width div 2).toFloat
  Cy = (Height div 2).toFloat
  RefreshFreq = 20

type
  Coords = tuple[x, y: float]
  Spinner = object
    pos: Coords
    radius: float
    angle: float
    speed: float
    color: Color
    lineWidth: float
  Simulation = object
    area: PDrawingArea
    spinners: array[5, Spinner]


proc angleLinePos(start: Coords; radius: float; angle: float): Coords =
  let a = degToRad(floorMod(angle, 360))
  result = (start.x - radius * cos(a), start.y - radius * sin(a))


proc init(spinner: var Spinner; pos: Coords; color: Color; radius = 10.0;
          speed = 110.0; startingAngle = 360.0; lineWidth = 2.0) =
  ## Initialize a spinner.
  spinner.pos = pos
  spinner.radius = radius
  spinner.angle = startingAngle
  spinner.speed = speed
  spinner.color = color
  spinner.lineWidth = lineWidth


proc setColor(cr: ptr Context; color: Color) =
  let (r, g, b) = color.extractRGB()
  cr.setSourceRgb(r / 255, g / 255, b / 255)


proc draw(cr: ptr Context; spinner: var Spinner) =
  ## Draw a spinner.
  cr.setColor(spinner.color)
  cr.setLineWidth(spinner.lineWidth)
  cr.moveTo(spinner.pos.x, spinner.pos.y)
  let endPos = angleLinePos(spinner.pos, spinner.radius, spinner.angle)
  cr.lineTo(endPos.x, endPos.y)
  cr.stroke
  spinner.angle = floorMod(spinner.angle - spinner.speed, 361)


proc update(sim: var Simulation): gboolean =
  ## Update the spinners.
  let cr = sim.area.window.cairoCreate()
  cr.setColor(colDarkSlateGray)
  cr.fill()
  cr.setColor(colDimGray)
  cr.arc(Cx, Cy, 100 + Radius + 2, 0, TAU)
  cr.fill()
  cr.setColor(colBlack)
  cr.arc(Cx, Cy, 100 + Radius, 0, TAU)
  cr.fill()
  for spinner in sim.spinners.mitems:
    cr.draw(spinner)
  result = true


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


nimInit()
let window = windowNew(WINDOW_TOPLEVEL)
window.setTitle("Animated spinners")
window.setSizeRequest(Width, Height)
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

var sim: Simulation

sim.spinners[0].init((Cx - Radius, Cy - Radius), colRed, Radius)
sim.spinners[1].init((Cx, Cy), colLightGreen, Radius)
sim.spinners[2].init((Cx + Radius, Cy - Radius), colYellow, Radius)
sim.spinners[3].init((Cx - Radius, Cy + Radius), colWhite, Radius)
sim.spinners[4].init((Cx + Radius, Cy + Radius), colOrange, Radius)

sim.area = drawingAreaNew()
window.add sim.area
discard timeoutAdd(RefreshFreq, cast[gtk2.TFunction](update), sim.addr)

window.showAll()
main()
