#!/usr/bin/env ocaml
#load "unix.cma"
#load "graphics.cma"
open Graphics

let pi = 4.0 *. atan 1.0
let angle v max = float v /. max *. 2.0 *. pi

let () =
  open_graph "";
  set_window_title "OCaml Clock";
  resize_window 256 256;
  auto_synchronize false;
  let w = size_x ()
  and h = size_y () in
  let rec loop () =
    clear_graph ();

    let point radius r a =
      let x = int_of_float (radius *. sin a)
      and y = int_of_float (radius *. cos a) in
      fill_circle (w/2+x) (h/2+y) r;
    in
    set_color (rgb 192 192 192);
    point 84.0 8 0.0;
    point 84.0 8 (angle  90 360.0);
    point 84.0 8 (angle 180 360.0);
    point 84.0 8 (angle 270 360.0);
    set_color (rgb 224 224 224);
    point 84.0 6 (angle  30 360.0);
    point 84.0 6 (angle  60 360.0);
    point 84.0 6 (angle 120 360.0);
    point 84.0 6 (angle 150 360.0);
    point 84.0 6 (angle 210 360.0);
    point 84.0 6 (angle 240 360.0);
    point 84.0 6 (angle 300 360.0);
    point 84.0 6 (angle 330 360.0);

    set_line_width 9;
    set_color (rgb 192 192 192);
    draw_circle (w/2) (h/2) 100;

    let tm = Unix.localtime (Unix.gettimeofday ()) in
    let sec = angle tm.Unix.tm_sec 60.0 in
    let min = angle tm.Unix.tm_min 60.0 in
    let hour = angle (tm.Unix.tm_hour * 60 + tm.Unix.tm_min) (24.0 *. 60.0) in
    let hour = hour *. 2.0 in

    let hand t radius width color =
      let x = int_of_float (radius *. sin t)
      and y = int_of_float (radius *. cos t) in
      set_line_width width;
      set_color color;
      moveto (w/2) (h/2);  rlineto x y;
    in
    hand sec  90.0 2 (rgb 0 128 255);
    hand min  82.0 4 (rgb 0 0 128);
    hand hour 72.0 6 (rgb 255 0 128);

    synchronize ();
    Unix.sleep 1;
    loop ()
  in
  try loop ()
  with _ -> close_graph ()
