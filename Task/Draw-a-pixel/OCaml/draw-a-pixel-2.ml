open Sdl

let () =
  let width, height = (320, 240) in
  Sdl.init [`VIDEO];
  let window, renderer =
    Render.create_window_and_renderer ~width ~height ~flags:[]
  in
  let rgb = (255, 0, 0) and a = 255 in
  Render.set_draw_color renderer ~rgb ~a;
  Render.draw_point renderer (100, 100);
  Render.render_present renderer;
  Timer.delay 3000;
  Sdl.quit ()
