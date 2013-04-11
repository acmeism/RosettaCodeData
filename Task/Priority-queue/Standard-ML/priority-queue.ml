structure TaskPriority = struct
  type priority = int
  val compare = Int.compare
  type item = int * string
  val priority : item -> int = #1
end

structure PQ = LeftPriorityQFn (TaskPriority)
;

let
  val tasks = [
    (3, "Clear drains"),
    (4, "Feed cat"),
    (5, "Make tea"),
    (1, "Solve RC tasks"),
    (2, "Tax return")]
  val pq = foldr PQ.insert PQ.empty tasks
  (* or val pq = PQ.fromList tasks *)
  fun aux pq' =
    case PQ.next pq' of
      NONE => ()
    | SOME ((prio, name), pq'') => (
        print (Int.toString prio ^ ", " ^ name ^ "\n");
        aux pq''
      )
in
  aux pq
end
