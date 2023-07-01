import random

import rapid/gfx

var
  window = initRWindow()
    .size(320, 240)
    .title("Rosetta Code - image noise")
    .open()
  surface = window.openGfx()

surface.loop:
  draw ctx, step:
    ctx.clear(gray(0))
    ctx.begin()
    for y in 0..window.height:
      for x in 0..window.width:
        if rand(0..1) == 0:
          ctx.point((x.float, y.float))
    ctx.draw(prPoints)
    echo 1 / (step / 60)
  update step:
    discard step
