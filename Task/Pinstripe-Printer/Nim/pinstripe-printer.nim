import gtk2, glib2, cairo

###############################################################################
# Missing declarations needed for print operations.

when defined(win32):
  const lib = "libgtk-win32-2.0-0.dll"
elif defined(macosx):
  const lib = "(libgtk-quartz-2.0.0.dylib|libgtk-x11-2.0.dylib)"
else:
  const lib = "libgtk-x11-2.0.so(|.0)"

# Missing type definitions.
type
  PrintOperation = PObject
  PrintContext = PObject
  PrintOperationAction = enum
    PRINT_OPERATION_ACTION_PRINT_DIALOG
    PRINT_OPERATION_ACTION_PRINT
    PRINT_OPERATION_ACTION_PREVIEW
    PRINT_OPERATION_ACTION_EXPORT
  PrintOperationResult = enum
    PRINT_OPERATION_RESULT_ERROR
    PRINT_OPERATION_RESULT_APPLY
    PRINT_OPERATION_RESULT_CANCEL
    PRINT_OPERATION_RESULT_IN_PROGRESS

# Missing external procedures.
proc print_operation_new(): PrintOperation {.cdecl,
    importc: "gtk_print_operation_new", dynlib: lib.}
proc print_operation_run(op: PrintOperation; action: PrintOperationAction;
                         parent: PWindow; error: pointer): PrintOperationResult {.cdecl,
    importc: "gtk_print_operation_run", dynlib: lib.}
proc set_n_pages(op: PrintOperation; n: gint) {.cdecl,
    importc: "gtk_print_operation_set_n_pages", dynlib: lib.}
proc get_cairo_context(printContext: PrintContext): ptr Context {.cdecl,
    importc: "gtk_print_context_get_cairo_context", dynlib: lib.}
proc width(printContext: PrintContext): cdouble {.cdecl,
    importc: "gtk_print_context_get_width", dynlib: lib.}
proc height(printContext: PrintContext): cdouble {.cdecl,
    importc: "gtk_print_context_get_height", dynlib: lib.}


###############################################################################

const Colors = [(1.0, 1.0, 1.0), (0.0, 0.0, 0.0)]


proc beginPrint(op: PrintOperation; printContext: PrintContext;
                data: Pgpointer): gboolean {.cdecl.} =
  ## Process "begin_print" signal.
  op.setNPages(1)   # Print one page.
  result = true


proc drawPage(op: PrintOperation; printContext: PrintContext;
              pageNum: int; data: Pgpointer): gboolean {.cdecl.} =
  ## Process "draw_page" signal.

  let context = printContext.get_cairo_context()
  let lineHeight = printContext.height / 4

  var y = 0.0
  for lineWidth in [1.0, 2.0, 3.0, 4.0]:
    context.setLineWidth(lineWidth)
    var x = 0.0
    var colorIndex = 0
    while x < printContext.width:
      let (r, g, b) = Colors[colorIndex]
      context.setSourceRgb(r, g, b)
      context.moveTo(x, y)
      context.lineTo(x, y + lineHeight)
      context.stroke()
      colorIndex = 1 - colorIndex
      x += lineWidth
    y += lineHeight

  result = true


nim_init()

# Print the pinstripe.
let op = print_operation_new()
discard op.g_signal_connect("begin_print", G_CALLBACK(begin_print), nil)
discard op.g_signal_connect("draw_page", G_CALLBACK(draw_page), nil)
discard op.print_operation_run(PRINT_OPERATION_ACTION_PRINT_DIALOG, nil, nil)
