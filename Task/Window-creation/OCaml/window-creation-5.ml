open Sdl

let () =
  let width, height = (640, 480) in
  Sdl.init [`VIDEO];
  let window, renderer =
    Render.create_window_and_renderer
        ~width ~height ~flags:[]
  in
  let rgb = (0, 255, 0) in
  let a = 255 in
  Render.set_draw_color renderer rgb a;
  Render.clear renderer;
  Render.render_present renderer;
  Timer.delay 3000;
  Sdl.quit ()
