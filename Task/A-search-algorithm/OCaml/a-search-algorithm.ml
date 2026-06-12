module IntPairs =
  struct
    type t = int * int
    let compare (x0,y0) (x1,y1) =
      match Stdlib.compare x0 x1 with
      | 0 -> Stdlib.compare y0 y1
      | c -> c
  end

module PairsMap = Map.Make(IntPairs)
module PairsSet = Set.Make(IntPairs)


let find_path start goal board =
  let max_y = Array.length board in
  let max_x = Array.length board.(0) in

  let get_neighbors (x, y) =
    let moves = [(0, 1); (0, -1); (1, 0); (-1, 0);
                 (1, 1); (1, -1); (-1, 1); (-1, -1)] in
    let ms = List.map (fun (_x, _y) -> x+_x, y+_y) moves in
    let ms = List.filter (fun (x, y) ->
        x >= 0 && x < max_x && y >= 0 && y < max_y
        && board.(y).(x) <> 0
      ) ms in
    (ms)
  in
  let h (x0, y0) (x1, y1) =
    abs (x0 - x1) + abs (y0 - y1)
  in
  let openSet = PairsSet.add start PairsSet.empty in
  let closedSet = PairsSet.empty in

  let fScore = PairsMap.add start (h goal start) PairsMap.empty in
  let gScore = PairsMap.add start 0 PairsMap.empty in

  let cameFrom = PairsMap.empty in

  let reconstruct_path cameFrom current =
    let rec aux acc current =
      let from = PairsMap.find current cameFrom in
      if from = start then (from::acc)
      else aux (from::acc) from
    in
    aux [current] current
  in
  let d current neighbor =
    let x, y = neighbor in
    board.(y).(x)
  in
  let g gScore cell =
    match PairsMap.find_opt cell gScore with
    | Some v -> v | None -> max_int
  in

  let rec _find_path (openSet, closedSet, fScore, gScore, cameFrom) =
    if PairsSet.is_empty openSet then None else
    let current =
      PairsSet.fold (fun p1 p2 ->
        if p2 = (-1, -1) then p1 else
          let s1 = PairsMap.find p1 fScore
          and s2 = PairsMap.find p2 fScore in
          if s1 < s2 then p1 else p2
      ) openSet (-1, -1)
    in
    if current = goal then Some (reconstruct_path cameFrom current) else
    let openSet = PairsSet.remove current openSet in
    let closedSet = PairsSet.add current closedSet in
    let neighbors = get_neighbors current in
    neighbors |>
      List.fold_left
        (fun ((openSet, closedSet, fScore, gScore, cameFrom) as v) neighbor ->
          if PairsSet.mem neighbor closedSet then (v) else
            let tentative_gScore = (g gScore current) + (d current neighbor) in
            if tentative_gScore < (g gScore neighbor) then
              let cameFrom = PairsMap.add neighbor current cameFrom in
              let gScore = PairsMap.add neighbor tentative_gScore gScore in
              let f = (g gScore neighbor) + (h neighbor goal) in
              let fScore = PairsMap.add neighbor f fScore in
              let openSet =
                if not (PairsSet.mem neighbor openSet)
                then PairsSet.add neighbor openSet else openSet
              in
              (openSet, closedSet, fScore, gScore, cameFrom)
            else (v)
        ) (openSet, closedSet, fScore, gScore, cameFrom)
    |> _find_path
  in
  _find_path (openSet, closedSet, fScore, gScore, cameFrom)


let () =
  let board = [|
    [| 1; 1; 1; 1; 1; 1; 1; 1; |];
    [| 1; 1; 1; 1; 1; 1; 1; 1; |];
    [| 1; 1; 1; 0; 0; 0; 1; 1; |];
    [| 1; 1; 1; 1; 1; 0; 1; 1; |];
    [| 1; 1; 0; 1; 1; 0; 1; 1; |];
    [| 1; 1; 0; 1; 1; 0; 1; 1; |];
    [| 1; 1; 0; 0; 0; 0; 1; 1; |];
    [| 1; 1; 1; 1; 1; 1; 1; 1; |];
  |] in
  let start = (0, 0) in
  let goal = (7, 7) in

  let dim_x = Array.length board.(0) in
  let dim_y = Array.length board in

  let r = find_path start goal board in

  match r with
  | None -> failwith "path not found"
  | Some p ->
      List.iter (fun (x, y) -> Printf.printf " (%d, %d)\n" x y) p;
      print_newline ();
      let _board =
        Array.init dim_y (fun y ->
          Array.init dim_x (fun x ->
            if board.(y).(x) = 0 then '#' else '.'))
      in
      List.iter (fun (x, y) -> _board.(y).(x) <- '*') p;

      Array.iter (fun line ->
        Array.iter (fun c ->
          Printf.printf " %c" c;
        ) line;
        print_newline ()
      ) _board;
      print_newline ()
