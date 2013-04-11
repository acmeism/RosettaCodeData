let subject_polygon =
  [ ( 50.0, 150.0); (200.0,  50.0); (350.0, 150.0);
    (350.0, 300.0); (250.0, 300.0); (200.0, 250.0);
    (150.0, 350.0); (100.0, 250.0); (100.0, 200.0); ]

let clip_polygon =
  [ (100.0, 100.0); (300.0, 100.0); (300.0, 300.0); (100.0, 300.0) ]

let () =
  Graphics.open_graph " 400x400";
  let to_grid poly =
    let round x = int_of_float (floor (x +. 0.5)) in
    Array.map
      (fun (x, y) -> (round x, round y))
      (Array.of_list poly)
  in
  let draw_poly fill stroke poly =
    let p = to_grid poly in
    Graphics.set_color fill;
    Graphics.fill_poly p;
    Graphics.set_color stroke;
    Graphics.draw_poly p;
  in
  draw_poly Graphics.red Graphics.blue subject_polygon;
  draw_poly Graphics.cyan Graphics.blue clip_polygon;
  draw_poly Graphics.magenta Graphics.blue (poly_clip subject_polygon clip_polygon);
  let _ = Graphics.wait_next_event [Graphics.Button_down; Graphics.Key_pressed] in
  Graphics.close_graph ()
