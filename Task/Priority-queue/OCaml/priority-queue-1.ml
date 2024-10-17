module PQ = Base.PriorityQueue

let () =
  let tasks = [
    3, "Clear drains";
    4, "Feed cat";
    5, "Make tea";
    1, "Solve RC tasks";
    2, "Tax return";
  ] in
  let pq = PQ.make (fun (prio1, _) (prio2, _) -> prio1 > prio2) in
  List.iter (PQ.add pq) tasks;
  while not (PQ.is_empty pq) do
    let _, task = PQ.first pq in
    PQ.remove_first pq;
    print_endline task
  done
