(* Function to print the Eulerian circuit *)
let print_circuit adj =
  if Array.length adj = 0 then
    () (* If the adjacency list is empty, do nothing *)
  else
    let curr_path = Stack.create () in
    let circuit = Stack.create () in

    (* Start with vertex 0 *)
    Stack.push 0 curr_path;

    while not (Stack.is_empty curr_path) do
      let curr_v = Stack.top curr_path in
      if adj.(curr_v) <> [] then
        (* Get the next vertex from the adjacency list *)
        let next_v = List.hd adj.(curr_v) in
        adj.(curr_v) <- List.tl adj.(curr_v); (* Remove the edge *)
        Stack.push next_v curr_path
      else
        (* Backtrack and add to the circuit *)
        Stack.push (Stack.pop curr_path) circuit
    done;

    (* Print the circuit in reverse order *)
    let rec print_stack s =
      if not (Stack.is_empty s) then (
        Printf.printf "%d" (Stack.pop s);
        if not (Stack.is_empty s) then Printf.printf " -> ";
        print_stack s
      )
    in
    print_stack circuit;
    Printf.printf "\n"

(* Main function *)
let () =
  (* First adjacency list *)
  let adj1 = Array.make 3 [] in
  adj1.(0) <- [1];
  adj1.(1) <- [2];
  adj1.(2) <- [0];
  print_circuit adj1;

  (* Second adjacency list *)
  let adj2 = Array.make 7 [] in
  adj2.(0) <- [1; 6];
  adj2.(1) <- [2];
  adj2.(2) <- [0; 3];
  adj2.(3) <- [4];
  adj2.(4) <- [2; 5];
  adj2.(5) <- [0];
  adj2.(6) <- [4];
  print_circuit adj2;
