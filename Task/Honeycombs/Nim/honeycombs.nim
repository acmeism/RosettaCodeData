import std/[lenientops, math, random, sequtils, strutils, tables]

import gtk2, gdk2, glib2, cairo


###############################################################################
# Missing gtk2 definition.

when defined(win32):
  const lib = "libgtk-win32-2.0-0.dll"
elif defined(macosx):
  const lib = "(libgtk-quartz-2.0.0.dylib|libgtk-x11-2.0.dylib)"
else:
  const lib = "libgtk-x11-2.0.so(|.0)"

proc setCanFocus(widget: PWidget; canFocus: bool) {.cdecl,
    importc: "gtk_widget_set_can_focus", dynlib: lib.}


###############################################################################

const
  Size = 308                  # Size of drawing area.
  NHexagons = 20              # Number of hexagons.
  Radius = 30.0
  XOffset = 1 + sin(PI / 6)
  YOffset = cos(PI / 6)

type

  # Description of a hexagon.
  Hexagon = object
    cx, cy: float
    letter: char
    selected: bool

  # Description of the honeycomb.
  HoneyComb = object
    hexagons: array[NHexagons, Hexagon]   # List of hexagons.
    indexes: Table[char, int]             # Mapping letter -> index of hexagon.
    archive: seq[char]                    # List of selected letters.
    label: PLabel                         # Label displaying the selected letters.


proc initHoneyComb(): HoneyComb =
  ## Create a honeycomb.
  var letters = toSeq('A'..'Z')
  letters.shuffle()
  for i in 0..<NHexagons:
    result.hexagons[i].letter = letters[i]
    result.indexes[letters[i]] = i
    # Compute position of hexagon center.
    let q = i shr 2
    let m = i and 3
    result.hexagons[i].cx = Radius * (2 + q * XOffset)
    result.hexagons[i].cy = Radius * (2 * (1 + m * YOffset) + (q and 1) * YOffset)


proc drawHexagons(context: ptr Context; honeyComb: HoneyComb; select: bool) =
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


proc drawLabels(context: ptr Context; honeyComb: HoneyComb; select: bool) =
  ## Draw the labels of the hexagons.
  for hex in honeyComb.hexagons:
    if select == hex.selected:
      let letter = cstring($hex.letter)
      var extents: TextExtents    # Used to adjust letter position in hexagon.
      context.textExtents(letter, extents.addr)
      context.moveTo(hex.cx - extents.width / 2, hex.cy + extents.height / 2)
      context.showText(letter)


proc onExposeEvent(area: PDrawingArea; event: PEventExpose; honeyComb: var HoneyComb): bool =
  ## Callback to draw/redraw the drawing area contents.

  let cr = cairoCreate(area.window)

  # Fill unselected in yellow.
  cr.setSourceRgba(0.8, 0.8, 0.0, 1.0)
  cr.drawHexagons(honeyComb, false)
  cr.fill()

  # Fill selected in purple.
  cr.setSourceRgba(0.8, 0.0, 0.8, 1.0)
  cr.drawHexagons(honeyComb, true)
  cr.fill()

  # Draw border.
  cr.setLineWidth(3.0)
  cr.setSourceRgba(0.7, 0.7, 0.7, 0.7)
  cr.drawHexagons(honeyComb, false)
  cr.stroke()

  # Prepare label drawing.
  cr.selectFontFace("cairo:monospace", FontSlantNormal, FontWeightBold)
  cr.setFontSize(14.0)

  # Draw labels for selected hexagons.
  cr.setSourceRgba(0, 0, 0, 1)
  cr.drawLabels(honeyComb, true)
  cr.stroke()

  # Draw labels for unselected hexagons.
  cr.setSourceRgba(0, 0, 1, 1)
  cr.drawLabels(honeyComb, false)
  cr.stroke()

  result = true


proc select(honeyComb: var HoneyComb; hex: var Hexagon) =
  ## Select a hexagon.
  hex.selected = true
  honeyComb.archive.add hex.letter
  let text = $honeyComb.label.getText() & hex.letter
  honeyComb.label.setText(text.cstring)


proc onButtonPress(area: PDrawingArea; event: PEventButton; honeyComb: var HoneyComb): bool =
  ## Callback to process a button press event.
  # Search the hexagon selected.
  for hex in honeyComb.hexagons.mitems:
    if hypot(event.x - hex.cx, event.y - hex.cy) < Radius * cos(PI / 15):
      if not hex.selected:
        honeyComb.select(hex)
        area.window.invalidateRect(nil, false)
      break
  return true


proc onKeyPress(area: PDrawingArea; event: PEventKey; honeyComb: var HoneyComb): bool =
  ## Callback to process a key press event.
  let keyval = event.keyval.int
  if keyval notin ord('a')..ord('z'): return false  # For ASCII letters, keyvals are ASCII codes.
  let letter = chr(keyval).toUpperAscii()           # We want the uppercase letter.
  if letter notin honeyComb.indexes: return false
  let idx = honeyComb.indexes[letter]
  if not honeyComb.hexagons[idx].selected:
    honeyComb.select(honeyComb.hexagons[idx])
    area.window.invalidateRect(nil, false)


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


randomize()
nimInit()

var honeyComb = initHoneyComb()
let window = windowNew(WINDOW_TOPLEVEL)
window.setTitle("Honeycombs")
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

let vbox = vboxNew(false, 1)
window.add vbox

honeyComb.label = labelNew(nil)
vbox.packEnd(honeyComb.label, false, false, 4)

# Create the drawing area.
let area = drawingAreaNew()
area.setEvents(BUTTON_PRESS_MASK or KEY_PRESS_MASK or EXPOSURE_MASK)
vbox.packStart(area, true, true, 4)
area.setSizeRequest(Size, Size)
area.setCanFocus(true)

# Connect events.
discard area.signalConnect("expose-event", SIGNAL_FUNC(onExposeEvent), honeyComb.addr)
discard area.signalConnect("button-press-event", SIGNAL_FUNC(onButtonPress), honeyComb.addr)
discard area.signalConnect("key-press-event", SIGNAL_FUNC(onKeyPress), honeyComb.addr)

window.showAll()
main()
