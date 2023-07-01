import sdl2

discard sdl2.init(INIT_EVERYTHING)

let window = createWindow("Pixel", 100, 100, 320, 240, SDL_WINDOW_SHOWN)
let renderer = createRenderer(window, -1, Renderer_Accelerated)

renderer.clear()
renderer.setDrawColor((255u8, 0u8, 0u8, 0u8))
renderer.drawPoint(100, 100)
renderer.present()

delay(5000)
