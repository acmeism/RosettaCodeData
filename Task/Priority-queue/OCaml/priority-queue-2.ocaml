module PQSet = Set.Make
  (struct
     type t = int * string (* pair of priority and task name *)
     let compare = compare
   end);;

let () =
  let tasks = [
    3, "Clear drains";
    4, "Feed cat";
    5, "Make tea";
    1, "Solve RC tasks";
    2, "Tax return";
  ] in
  let pq = PQSet.of_list tasks in
  let rec aux pq' =
    if not (PQSet.is_empty pq') then begin
      let prio, name as task = PQSet.min_elt pq' in
      Printf.printf "%d, %s\n" prio name;
      aux (PQSet.remove task pq')
    end
  in aux pq
