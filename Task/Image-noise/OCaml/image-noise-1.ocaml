let frames =
  { contents = 0 }

let t_acc =
  { contents = 0 }

let last_t =
  { contents = Sdltimer.get_ticks () }

let print_fps () =
  let t = Sdltimer.get_ticks () in
  let dt = t - !last_t in
  t_acc := !t_acc + dt;
  if !t_acc > 1000 then begin
    let el_time = !t_acc / 1000 in
    Printf.printf
      "- fps: %g\n%!"
      (float !frames /. float el_time);
    t_acc := 0;
    frames := 0;
  end;
  last_t := t

let blit_noise surf =
  let ba = Sdlvideo.pixel_data_8 surf in
  let dim = Bigarray.Array1.dim ba in
  while true do
    for i = 0 to pred dim do
      ba.{i} <- if Random.bool () then max_int else 0
    done;
    Sdlvideo.flip surf;
    incr frames;
    print_fps ()
  done

let blit_noise surf =
  try blit_noise surf
  with _ -> Sdl.quit ()

let () =
  Sdl.init [`VIDEO; `TIMER];
  Random.self_init();
  let surf =
    Sdlvideo.set_video_mode
      ~w:320 ~h:240 ~bpp:8
      [(*`HWSURFACE;*) `DOUBLEBUF]
  in
  Sys.catch_break true;
  blit_noise surf
