type document  // abstract type for a document object
type context = { mutable fillStyle: string, }

@val external doc: document = "document"

@send external getElementById: (document, string) => Dom.element = "getElementById"
@send external getContext: (Dom.element, string) => context = "getContext"

@send external fillRect: (context, int, int, int, int) => unit = "fillRect"

let canvas = getElementById(doc, "my_canvas")
let ctx = getContext(canvas, "2d")

ctx.fillStyle = "#F00"
fillRect(ctx, 100, 100, 1, 1)
