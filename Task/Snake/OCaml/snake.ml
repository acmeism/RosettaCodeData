(* A simple Snake Game *)
open Sdl

let width, height = (640, 480)

type pos = int * int

type game_state = {
  pos_snake: pos;
  seg_snake: pos list;
  dir_snake: [`left | `right | `up | `down];
  pos_fruit: pos;
  sleep_time: int;
  game_over: bool;
}

let red   = (255, 0, 0)
let blue  = (0, 0, 255)
let green = (0, 255, 0)
let black = (0, 0, 0)
let alpha = 255

let fill_rect renderer (x, y) =
  let rect = Rect.make4 x y 20 20 in
  Render.fill_rect renderer rect;
;;


let display_game renderer state =
  let bg_color, snake_color, fruit_color =
    if state.game_over
    then (red, black, green)
    else (black, blue, red)
  in
  Render.set_draw_color renderer bg_color alpha;
  Render.clear renderer;
  Render.set_draw_color renderer fruit_color alpha;
  fill_rect renderer state.pos_fruit;
  Render.set_draw_color renderer snake_color alpha;
  List.iter (fill_rect renderer) state.seg_snake;
  Render.render_present renderer;
;;


let proc_events dir_snake = function
  | Event.KeyDown { Event.keycode = Keycode.Left } -> `left
  | Event.KeyDown { Event.keycode = Keycode.Right } -> `right
  | Event.KeyDown { Event.keycode = Keycode.Up } -> `up
  | Event.KeyDown { Event.keycode = Keycode.Down } -> `down
  | Event.KeyDown { Event.keycode = Keycode.Q }
  | Event.KeyDown { Event.keycode = Keycode.Escape }
  | Event.Quit _ -> Sdl.quit (); exit 0
  | _ -> (dir_snake)


let rec event_loop dir_snake =
  match Event.poll_event () with
  | None -> (dir_snake)
  | Some ev ->
      let dir = proc_events dir_snake ev in
      event_loop dir


let rec pop = function
  | [_] -> []
  | hd :: tl -> hd :: (pop tl)
  | [] -> invalid_arg "pop"


let rec new_pos_fruit seg_snake =
  let new_pos =
    (20 * Random.int 32,
     20 * Random.int 24)
  in
  if List.mem new_pos seg_snake
  then new_pos_fruit seg_snake
  else (new_pos)


let update_state req_dir ({
    pos_snake;
    seg_snake;
    pos_fruit;
    dir_snake;
    sleep_time;
    game_over;
  } as state) =
  if game_over then state else
  let dir_snake =
    match dir_snake, req_dir with
    | `left, `right -> dir_snake
    | `right, `left -> dir_snake
    | `up, `down -> dir_snake
    | `down, `up -> dir_snake
    | _ -> req_dir
  in
  let pos_snake =
    let x, y = pos_snake in
    match dir_snake with
    | `left  -> (x - 20, y)
    | `right -> (x + 20, y)
    | `up    -> (x, y - 20)
    | `down  -> (x, y + 20)
  in
  let game_over =
    let x, y = pos_snake in
    List.mem pos_snake seg_snake
    || x < 0 || y < 0
    || x >= width
    || y >= height
  in
  let seg_snake = pos_snake :: seg_snake in
  let seg_snake, pos_fruit, sleep_time =
    if pos_snake = pos_fruit
    then (seg_snake, new_pos_fruit seg_snake, sleep_time - 1)
    else (pop seg_snake, pos_fruit, sleep_time)
  in
  { pos_snake;
    seg_snake;
    pos_fruit;
    dir_snake;
    sleep_time;
    game_over;
  }


let () =
  Random.self_init ();
  Sdl.init [`VIDEO];
  let window, renderer =
    Render.create_window_and_renderer ~width ~height ~flags:[]
  in
  Window.set_title ~window ~title:"Snake OCaml-SDL2";
  let initial_state = {
    pos_snake = (100, 100);
    seg_snake = [
      (100, 100);
      ( 80, 100);
      ( 60, 100);
    ];
    pos_fruit = (200, 200);
    dir_snake = `right;
    sleep_time = 120;
    game_over = false;
  } in

  let rec main_loop state =
    let req_dir = event_loop state.dir_snake in
    let state = update_state req_dir state in
    display_game renderer state;
    Timer.delay state.sleep_time;
    main_loop state
  in
  main_loop initial_state
