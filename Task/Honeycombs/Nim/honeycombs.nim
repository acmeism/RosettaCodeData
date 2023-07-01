import lenientops, math, random, sequtils, strutils, tables

import gintro/[gobject, gdk, gtk, gio, cairo]
import gintro/glib except PI

const
  Size = 308                  # Size of drawing area.
  NHexagons = 20              # Number of hexagons.
  Radius = 30.0
  XOffset = 1 + sin(PI / 6)
  YOffset = cos(PI / 6)

type

  Letter = range['A'..'Z']

  # Description of a hexagon.
  Hexagon = object
    cx, cy: float
    letter: Letter
    selected: bool

  # Description of the honeycomb.
  HoneyComb = ref object
    hexagons: array[NHexagons, Hexagon]   # List of hexagons.
    indexes: tables.Table[char, int]      # Mapping letter -> index of hexagon.
    archive: seq[Letter]                  # List of selected letters.
    label: Label                          # Label displaying the selected letters.

#---------------------------------------------------------------------------------------------------

proc newHoneyComb(): HoneyComb =
  ## Create a honeycomb.

  new(result)
  var letters = toSeq('A'..'Z')
  letters.shuffle()

  for i in 0..<NHexagons:
    result.hexagons[i].letter = letters[i]
    result.indexes[letters[i]] = i
    # Compute position of hexagon center.
    let q = i div 4
    let m = i mod 4
    result.hexagons[i].cx = Radius * (2 + q * XOffset)
    result.hexagons[i].cy = Radius * (2 * (1 + m * YOffset) + (q and 1) * YOffset)

#---------------------------------------------------------------------------------------------------

proc drawHexagons(context: Context; honeyComb: HoneyComb; select: bool) =
  ## Draw a hexagon (content or border).

  for hex in honeyComb.hexagons:
    if select == hex.selected:
      let cx = hex.cx
      let cy = hex.cy
      context.moveTo(cx + Radius, cy)
      for i in 1..5:
        let x = cx + Radius * cos(i * PI / 3)
        let y = cy + Radius * sin(i * PI / 3)
        context.lineTo(x, y)

#---------------------------------------------------------------------------------------------------

proc drawLabels(context: Context; honeyComb: HoneyComb; select: bool) =
  ## Draw the labels of the hexagons.

  for hex in honeyComb.hexagons:
    if select == hex.selected:
      let letter = $hex.letter
      var extents: TextExtents    # Used to adjust letter position in hexagon.
      context.getTextExtents(letter, extents)
      context.moveTo(hex.cx - extents.width / 2, hex.cy + extents.height / 2)
      context.showText(letter)

#---------------------------------------------------------------------------------------------------

proc onDraw(area: DrawingArea; context: Context; honeyComb: HoneyComb): bool =
  ## Callback to draw/redraw the drawing area contents.

  # Fill unselected in yellow.
  context.setSource(0.8, 0.8, 0.0, 1.0)
  context.drawHexagons(honeyComb, false)
  context.fill()

  # Fill selected in purple.
  context.setSource(0.8, 0.0, 0.8, 1.0)
  context.drawHexagons(honeyComb, true)
  context.fill()

  # Draw border.
  context.setLineWidth(3.0)
  context.setSource(0.7, 0.7, 0.7, 0.7)
  context.drawHexagons(honeyComb, false)
  context.stroke()

  # Prepare label drawing.
  context.selectFontFace("cairo:monospace", FontSlant.normal, FontWeight.bold)
  context.setFontSize(14.0)

  # Draw labels for selected hexagons.
  context.setSource(0, 0, 0, 1)
  context.drawLabels(honeyComb, true)
  context.stroke()

  # Draw labels for unselected hexagons.
  context.setSource(0, 0, 1, 1)
  context.drawLabels(honeyComb, false)
  context.stroke()

  result = true

#---------------------------------------------------------------------------------------------------

proc select(honeyComb: HoneyComb; hex: var Hexagon) =
  ## Select a hexagon.

  hex.selected = true
  honeyComb.archive.add(hex.letter)
  honeyComb.label.setText(honeyComb.label.text() & hex.letter)

#---------------------------------------------------------------------------------------------------

proc onButtonPress(area: DrawingArea; event: Event; honeyComb: HoneyComb): bool =
  ## Callback to process a button press event.

  var xwin, ywin: float
  if not event.getCoords(xwin, ywin): return false

  # Search the hexagon selected.
  for hex in honeyComb.hexagons.mitems:
    if hypot(xwin - hex.cx, ywin - hex.cy) < Radius * cos(PI / 15):
      if not hex.selected:
        honeyComb.select(hex)
        area.window().invalidateRect()
      break
  return true

#---------------------------------------------------------------------------------------------------

proc onKeyPress(area: DrawingArea; event: Event; honeyComb: HoneyComb): bool =
  ## Callbakc to process a key press event.

  var keyval: int
  if not event.getKeyval(keyval): return false
  if keyval notin ord('a')..ord('z'): return false  # For ASCII letters, keyvals are ASCII codes.
  let letter = chr(keyval).toUpperAscii()           # We want the uppercase letter.
  if letter notin honeyComb.indexes: return false
  let idx = honeyComb.indexes[letter]
  if not honeyComb.hexagons[idx].selected:
    honeyComb.select(honeyComb.hexagons[idx])
    area.window().invalidateRect()

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  var honeyComb = newHoneyComb()

  let window = app.newApplicationWindow()
  window.setTitle("Honeycombs")

  let vbox = newBox(Orientation.vertical, 1)
  window.add(vbox)

  honeyComb.label = newLabel()
  vbox.packEnd(honeyComb.label, false, false, 4)

  # Create the drawing area.
  let area = newDrawingArea()
  area.setEvents({EventFlag.buttonPress, EventFlag.keyPress, EventFlag.exposure})
  vbox.packStart(area, true, true, 4)
  area.setSizeRequest(Size, Size)
  area.setCanFocus(true)

  # Connect events.
  discard area.connect("draw", ondraw, honeyComb)
  discard area.connect("button-press-event", onButtonPress, honeyComb)
  discard area.connect("key-press-event", onKeyPress, honeyComb)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

randomize()
let app = newApplication(Application, "Rosetta.honeycombs")
discard app.connect("activate", activate)
discard app.run()
