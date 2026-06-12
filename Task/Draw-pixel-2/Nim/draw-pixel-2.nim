import random
import sdl2

discard sdl2.init(INIT_EVERYTHING)

let window = createWindow("Pixel", 300, 300, 640, 480, SDL_WINDOW_SHOWN)
let renderer = createRenderer(window, -1, Renderer_Accelerated)

randomize()
renderer.clear()
renderer.setDrawColor((255u8, 255u8, 0u8, 0u8))
let x = rand(639)
let y = rand(479)
renderer.drawPoint(x.cint, y.cint)
renderer.present()

delay(5000)
