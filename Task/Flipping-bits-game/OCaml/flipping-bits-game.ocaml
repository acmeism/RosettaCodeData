module FlipGame =
struct
  type t = bool array array

  let make side = Array.make_matrix side side false

  let flipcol b n =
    for i = 0 to (Array.length b - 1) do
      b.(n).(i) <- not b.(n).(i)
    done

  let fliprow b n =
    for i = 0 to (Array.length b - 1) do
      b.(i).(n) <- not b.(i).(n)
    done

  let randflip b =
    let n = Random.int (Array.length b - 1) in
    match Random.bool () with
    | true -> fliprow b n
    | false -> flipcol b n

  let rec game side steps =
    let start, target = make side, make side in
    for i = 1 to steps do
      randflip start;
      randflip target
    done;
    if start = target then game side steps (* try again *) else
      (start, target)

  let print b =
    for i = 0 to Array.length b - 1 do
      for j = 0 to Array.length b - 1 do
        Printf.printf " %d " (if b.(j).(i) then 1 else 0)
      done;
      print_newline ()
    done;
    print_newline ()

  let draw_game board target =
    print_endline "TARGET"; print target;
    print_endline "BOARD"; print board
end

let play () =
  let module G = FlipGame in
  let board, target = G.game 3 10 in
  let steps = ref 0 in
  while board <> target do
    G.draw_game board target;
    print_string "> ";
    flush stdout;
    incr steps;
    match String.split_on_char ' ' (read_line ()) with
    | ["row"; row] ->
      (match int_of_string_opt row with
       | Some n -> G.fliprow board n
       | None -> print_endline "(nothing happens)")
    | ["col"; col] ->
      (match int_of_string_opt col with
       | Some n -> G.flipcol board n
       | None -> print_endline "(nothing happens)")
    | _ -> ()
  done;
  G.draw_game board target;
  Printf.printf "\n\nGame solved in %d steps\n" !steps

let () =
  if not !Sys.interactive then
    (Random.self_init ();
      play ())
