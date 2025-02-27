import cairo

const
  Width = 600
  Height = 400


proc drawBars(surface: ptr Surface) =
  ## Draw the color bars.

  const Colors = [(0.0, 0.0, 0.0),  # Black.
                  (1.0, 0.0, 0.0),  # Red.
                  (0.0, 1.0, 0.0),  # Green.
                  (0.0, 0.0, 1.0),  # Blue.
                  (1.0, 0.0, 1.0),  # Magenta.
                  (0.0, 1.0, 1.0),  # Cyan.
                  (1.0, 1.0, 0.0),  # Yellow.
                  (1.0, 1.0, 1.0)   # White.
                 ]

  const
    RectWidth = float(Width div Colors.len)
    RectHeight = float(Height)

  let context = create(surface)

  var x = 0.0
  for (r, g, b) in Colors:
    context.rectangle(x, 0, RectWidth, RectHeight)
    context.setSourceRgb(r, g, b)
    context.fill()
    x += RectWidth

  context.destroy()


let surface = imageSurfaceCreate(FormatRgb24, 600, 400)
surface.drawBars()
if surface.writeToPng("color_bars.png") != StatusSuccess:
  quit "Error while writing file.", QuitFailure
surface.destroy()
