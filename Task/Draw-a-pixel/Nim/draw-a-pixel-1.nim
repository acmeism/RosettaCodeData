import rapid/gfx

var
  window = initRWindow()
    .size(320, 240)
    .title("Rosetta Code - draw a pixel")
    .open()
  surface = window.openGfx()

surface.loop:
  draw ctx, step:
    ctx.clear(gray(0))
    ctx.begin()
    ctx.point((100.0, 100.0, rgb(255, 0, 0)))
    ctx.draw(prPoints)
    discard step # Prevent unused variable warnings
  update step:
    discard step
