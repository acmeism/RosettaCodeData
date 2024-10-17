let pi = 4.0 *. atan 1.0
let angle v max = float v /. max *. 2.0 *. pi

let draw area _ =
  let cr = Cairo_lablgtk.create area#misc#window in
  let { Gtk.width = width; Gtk.height = height } = area#misc#allocation in
  let scale p = float (min width height) *. 0.5 *. p in
  let center_x, center_y = float width /. 2.0, float height /. 2.0 in
  let invert_y y = float height -. y in

  Cairo.set_source_rgb cr 0.8 0.8 0.8;
  Cairo.paint cr;  (* background *)

  Cairo.set_source_rgb cr 1.0 1.0 1.0;

  Cairo.arc cr center_x center_y (scale 0.9) 0.0 (2.0 *. pi);
  Cairo.set_line_width cr (scale 0.02);
  Cairo.stroke cr;

  let point a =
    let radius = (scale 0.9) in
    let x = radius *. sin a
    and y = radius *. cos a in
    let r = scale 0.04 in
    Cairo.arc cr (center_x +. x) (invert_y (center_y +. y)) r 0.0 (2.0 *. pi);
    Cairo.fill cr;
  in
  for i = 0 to pred 12 do
    point (angle (i * 30) 360.0)
  done;

  let tm = Unix.localtime (Unix.gettimeofday ()) in
  let sec = angle tm.Unix.tm_sec 60.0 in
  let min = angle tm.Unix.tm_min 60.0 in
  let hour = angle (tm.Unix.tm_hour * 60 + tm.Unix.tm_min) (12.0 *. 60.0) in

  Cairo.set_line_cap cr Cairo.LINE_CAP_ROUND;

  let hand t radius lwidth (r, g, b) =
    let x = radius *. sin t
    and y = radius *. cos t in
    Cairo.set_line_width cr (scale lwidth);
    Cairo.move_to cr center_x center_y;
    Cairo.line_to cr (center_x +. x) (invert_y (center_y +. y));
    Cairo.set_source_rgb cr r g b;
    Cairo.stroke cr;
  in
  hand sec  (scale 0.9) 0.04 (0.0, 0.5, 1.0);
  hand min  (scale 0.7) 0.06 (0.0, 0.0, 0.5);
  hand hour (scale 0.6) 0.09 (1.0, 0.0, 0.5);
  true

let animate area =
  ignore (GMain.Timeout.add 200 (fun () ->
    GtkBase.Widget.queue_draw area#as_widget; true))

let () =
  let w = GWindow.window ~title:"OCaml GtkCairo Clock" () in
  ignore (w#connect#destroy GMain.quit);
  let f = GBin.frame ~shadow_type:`IN ~packing:w#add () in
  let area = GMisc.drawing_area ~width:200 ~height:200 ~packing:f#add () in
  area#misc#set_double_buffered true;
  ignore (area#event#connect#expose (draw area));
  animate area;
  w#show ();
  GMain.main ()
