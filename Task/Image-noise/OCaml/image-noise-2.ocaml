open Graphics

let white = (rgb 255 255 255)
let black = (rgb 0 0 0)

let t_last = ref (Unix.gettimeofday())

let () =
  open_graph "";
  let width = 320
  and height = 240 in
  resize_window width height;
  try
    while true do
      for y = 0 to pred height do
        for x = 0 to pred width do
          set_color (if Random.bool() then white else black);
          plot x y
        done;
      done;
      let t = Unix.gettimeofday() in
      Printf.printf "- fps: %f\n" (1.0 /. (t -. !t_last));
      t_last := t
    done
  with _ ->
    flush stdout;
    close_graph ()
