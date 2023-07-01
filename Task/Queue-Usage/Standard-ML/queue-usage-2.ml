- open Queue;
opening Queue
  type 'a queue
  exception Dequeue
  val mkQueue : unit -> 'a queue
  val clear : 'a queue -> unit
  val isEmpty : 'a queue -> bool
  val enqueue : 'a queue * 'a -> unit
  val dequeue : 'a queue -> 'a
  val next : 'a queue -> 'a option
  val delete : 'a queue * ('a -> bool) -> unit
  val head : 'a queue -> 'a
  val peek : 'a queue -> 'a option
  val length : 'a queue -> int
  val contents : 'a queue -> 'a list
  val app : ('a -> unit) -> 'a queue -> unit
  val map : ('a -> 'b) -> 'a queue -> 'b queue
  val foldl : ('a * 'b -> 'b) -> 'b -> 'a queue -> 'b
  val foldr : ('a * 'b -> 'b) -> 'b -> 'a queue -> 'b
- val q : int queue = mkQueue ();
val q = - : int queue
- isEmpty q;
val it = true : bool
- enqueue (q, 1);
val it = () : unit
- isEmpty q;
val it = false : bool
- enqueue (q, 2);
val it = () : unit
- enqueue (q, 3);
val it = () : unit
- peek q;
val it = SOME 1 : int option
- length q;
val it = 3 : int
- contents q;
val it = [1,2,3] : int list
- dequeue q;
val it = 1 : int
- dequeue q;
val it = 2 : int
- peek q;
val it = SOME 3 : int option
- length q;
val it = 1 : int
- enqueue (q, 4);
val it = () : unit
- dequeue q;
val it = 3 : int
- peek q;
val it = SOME 4 : int option
- dequeue q;
val it = 4 : int
- isEmpty q;
val it = true : bool
