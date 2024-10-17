let alive = 0
let dead = 0xFFFFFF

let iteration ib ob m n =
   let rule = function 3,_ | 2,true -> alive | _ -> dead in
   let f x y =
      if x >= 0 && x < m && y >= 0 && y < n && ib.(x).(y) = alive
      then 1 else 0 in
   let count b q =
      let a, c, p, r = b-1, b+1, q-1, q+1 in
      f a p + f a q + f a r + f b p + f b r + f c p + f c q + f c r in
   for i = 0 to m-1 do
      for j = 0 to n-1 do
         ob.(i).(j) <- rule (count i j, ib.(i).(j) = alive)
      done
   done

let make_random w h bd =
   Random.self_init ();
   for i = 0 to w-1 do
      for j = 0 to h-1 do
         bd.(i).(j) <- if Random.bool () then alive else dead
      done
   done

let set_cells a b cells w h bd =
   let w', h' = w/2 - a, h/2 - b in
   List.iter (fun (i,j) -> bd.(i+w').(j+h') <- alive) cells

let make_blinker = set_cells 1 1 [(1,0); (1,1); (1,2)]

let make_acorn =
   set_cells 1 3 [(0,1); (1,3); (2,0); (2,1); (2,4); (2,5); (2,6)]

let make_growth =
   set_cells 2 3
   [(0,6); (1,4); (1,6); (1,7); (2,4); (2,6); (3,4); (4,2); (5,0); (5,2)]

let make_rabbits =
   set_cells 1 3
   [(0,0); (0,4); (0,5); (0,6); (1,0); (1,1); (1,2); (1,5); (2,1)]

let make_engine =
   set_cells (-100) (-100)
   [(0,1); (0,3); (1,0); (2,1); (2,4); (3,3); (3,4); (3,5); (4,26); (4,27); (5,26); (5,27)]

let make_line w h bd =
   let w', h', l = w/2, h/2, w/3 in
   for i = -l to l do bd.(i+w').(h') <- alive done

let () =
   let argc = Array.length Sys.argv in
   let init =
      let default () = (print_endline "Using random start"; make_random) in
      if argc < 2 then default () else
      match Sys.argv.(1) with
         | "acorn" -> make_acorn
         | "blinker" -> make_blinker
         | "growth" -> make_growth
         | "engine" -> make_engine
         | "line" -> make_line
         | "rabbits" -> make_rabbits
         | "random" -> make_random
         | "-h" -> Printf.printf
            "Usage: %s [acorn|growth|blinker|engine|line|rabbits|random] width height\n" Sys.argv.(0);
            exit 0
         | _ -> default () in
   let width = if argc > 2 then int_of_string Sys.argv.(2) else 300 in
   let height = if argc > 3 then int_of_string Sys.argv.(3) else 300 in
   let bd1 = Array.make_matrix width height dead in
   let bd2 = Array.make_matrix width height dead in
   let border = 5 in
   let disp m = Graphics.draw_image (Graphics.make_image m) border border in
   init width height bd1;
   Graphics.open_graph (Printf.sprintf " %dx%d" (height+2*border) (width+2*border));
   while true do
      disp bd1;
      iteration bd1 bd2 width height;
      disp bd2;
      iteration bd2 bd1 width height
   done
