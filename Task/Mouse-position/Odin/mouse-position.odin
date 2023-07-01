package main

import "core:fmt"
import "vendor:sdl2"

main :: proc() {
  using sdl2

  window: ^Window = ---
  renderer: ^Renderer = ---
  event: Event = ---

  Init(INIT_VIDEO)
  CreateWindowAndRenderer(
    640, 480,
    WINDOW_SHOWN,
    &window, &renderer
  )

  SetWindowTitle(window, "Empty window")
  RenderPresent(renderer)

  for event.type != .QUIT {
    if event.type == .MOUSEMOTION {
      using event.motion
      fmt.printf("x=%d y=%d\n", x, y)
    }
    Delay(10)
    PollEvent(&event)
  }

  DestroyRenderer(renderer)
  DestroyWindow(window)
  Quit()
}
