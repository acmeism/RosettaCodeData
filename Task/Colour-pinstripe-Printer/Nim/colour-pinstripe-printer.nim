import gintro/[glib, gobject, gtk, gio, cairo]

const Colors = [[0.0, 0.0, 0.0], [255.0, 0.0, 0.0],
                [0.0, 255.0, 0.0], [0.0, 0.0, 255.0],
                [255.0, 0.0, 255.0], [0.0, 255.0, 255.0],
                [255.0, 255.0, 0.0], [255.0, 255.0, 255.0]]

#---------------------------------------------------------------------------------------------------

proc beginPrint(op: PrintOperation; printContext: PrintContext; data: pointer) =
  ## Process signal "begin_print", that is set the number of pages to print.
  op.setNPages(1)

#---------------------------------------------------------------------------------------------------

proc drawPage(op: PrintOperation; printContext: PrintContext; pageNum: int; data: pointer) =
  ## Draw a page.

  let context = printContext.getCairoContext()
  let lineHeight = printContext.height / 4

  var y = 0.0
  for lineWidth in [1.0, 2.0, 3.0, 4.0]:
    context.setLineWidth(lineWidth)
    var x = 0.0
    var colorIndex = 0
    while x < printContext.width:
      context.setSource(Colors[colorIndex])
      context.moveTo(x, y)
      context.lineTo(x, y + lineHeight)
      context.stroke()
      colorIndex = (colorIndex + 1) mod Colors.len
      x += lineWidth
    y += lineHeight

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  # Launch a print operation.
  let op = newPrintOperation()
  op.connect("begin_print", beginPrint, pointer(nil))
  op.connect("draw_page", drawPage, pointer(nil))

  # Run the print dialog.
  discard op.run(printDialog)

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.ColorPinstripe")
discard app.connect("activate", activate)
discard app.run()
