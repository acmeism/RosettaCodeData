let kosaraju (successors : int list array) =
  let n = Array.length successors in
  let marked = Array.make n false in
  let predecessors = Array.make n [] in
  let components = Array.make n (-1) in
  let stack = ref [] in
  let rec visit u =
    if not marked.(u) then (
      marked.(u) <- true;
      List.iter
        (fun v ->
          visit v;
          predecessors.(v) <- u :: predecessors.(v))
        successors.(u);
      stack := u :: !stack)
  in
  for u = 0 to n - 1 do
    visit u
  done;
  let rec assign root u =
    if marked.(u) then (
      marked.(u) <- false;
      components.(u) <- root;
      List.iter (assign root) predecessors.(u))
  in
  List.iter (fun u -> assign u u) !stack;
  components

let _ = kosaraju [|[1]; [2]; [0]; [1; 2; 4]; [3; 5]; [2; 6]; [5]; [4; 6; 7]|]
