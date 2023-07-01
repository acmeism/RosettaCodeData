import random

import rapid/gfx

var
  window = initRWindow()
    .size(320, 240)
    .title("Rosetta Code - image noise")
    .open()
  surface = window.openGfx()

let
  noiseShader = surface.newRProgram(RDefaultVshSrc, """
    uniform float time;

    float rand(vec2 pos) {
      return fract(sin(dot(pos.xy + time, vec2(12.9898,78.233))) * 43758.5453123);
    }

    vec4 rFragment(vec4 col, sampler2D tex, vec2 pos, vec2 uv) {
      return vec4(vec3(step(0.5, rand(uv))), 1.0);
    }
  """)

surface.vsync = false
surface.loop:
  draw ctx, step:
    noiseShader.uniform("time", time())
    ctx.program = noiseShader
    ctx.begin()
    ctx.rect(0, 0, surface.width, surface.height)
    ctx.draw()
    echo 1 / (step / 60)
  update step:
    discard step
