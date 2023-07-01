let imp_catalan n =
  let return = ref 1 in
  for i = 1 to n do
    return := !return * 2 * (2 * i - 1) / (i + 1)
  done;
  !return

let rec catalan = function
  | 0 -> 1
  | n -> catalan (n - 1) * 2 * (2 * n - 1) / (n + 1)

let memoize f =
  let cache = Hashtbl.create 20 in
  fun n ->
    match Hashtbl.find_opt cache n with
    | None ->
      let x = f n in
      Hashtbl.replace cache n x;
      x
    | Some x -> x

let catalan_cache = Hashtbl.create 20

let rec memo_catalan n =
  if n = 0 then 1 else
    match Hashtbl.find_opt catalan_cache n with
    | None ->
      let x = memo_catalan (n - 1) * 2 * (2 * n - 1) / (n + 1) in
      Hashtbl.replace catalan_cache n x;
      x
    | Some x -> x

let () =
  if not !Sys.interactive then
    let bench label f n times =
      let start = Unix.gettimeofday () in
      begin
        for i = 1 to times do f n done;
        let stop = Unix.gettimeofday () in
        Printf.printf "%s (%d runs) : %.3f\n"
          label times (stop -. start)
      end in
    let show f g h f' n =
      for i = 0 to n do
        Printf.printf "%2d %7d %7d %7d %7d\n"
          i (f i) (g i) (h i) (f' i)
      done
    in
    List.iter (fun (l, f) -> bench l f 15 10_000_000)
      ["imperative", imp_catalan;
       "recursive", catalan;
       "hand-memoized", memo_catalan;
       "memoized", (memoize catalan)];
    show imp_catalan catalan memo_catalan (memoize catalan) 15
