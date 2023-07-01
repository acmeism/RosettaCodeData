import gintro/cairo

proc draw(ctx: Context; x, y, r: float) =
  ctx.arc(x, y, r + 1, 1.571, 7.854)
  ctx.setSource(0.0, 0.0, 0.0)
  ctx.fill()
  ctx.arcNegative(x, y - r / 2, r / 2, 1.571, 4.712)
  ctx.arc(x, y + r / 2, r / 2, 1.571, 4.712)
  ctx.arcNegative(x, y, r, 4.712, 1.571)
  ctx.setSource(1.0, 1.0, 1.0)
  ctx.fill()
  ctx.arc(x, y - r / 2, r / 5, 1.571, 7.854)
  ctx.setSource(0.0, 0.0, 0.0)
  ctx.fill()
  ctx.arc(x, y + r / 2, r / 5, 1.571, 7.854)
  ctx.setSource(1.0, 1.0, 1.0)
  ctx.fill()

let surface = imageSurfaceCreate(argb32, 200, 200)
let context = newContext(surface)
context.draw(120, 120, 75)
context.draw(35, 35, 30)
let status = surface.writeToPng("yin-yang.png")
assert status == Status.success
