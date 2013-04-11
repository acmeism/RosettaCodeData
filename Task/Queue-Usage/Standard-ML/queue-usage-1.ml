- open Fifo;
opening Fifo
  datatype 'a fifo = ...
  exception Dequeue
  val empty : 'a fifo
  val isEmpty : 'a fifo -> bool
  val enqueue : 'a fifo * 'a -> 'a fifo
  val dequeue : 'a fifo -> 'a fifo * 'a
  val next : 'a fifo -> ('a * 'a fifo) option
  val delete : 'a fifo * ('a -> bool) -> 'a fifo
  val head : 'a fifo -> 'a
  val peek : 'a fifo -> 'a option
  val length : 'a fifo -> int
  val contents : 'a fifo -> 'a list
  val app : ('a -> unit) -> 'a fifo -> unit
  val map : ('a -> 'b) -> 'a fifo -> 'b fifo
  val foldl : ('a * 'b -> 'b) -> 'b -> 'a fifo -> 'b
  val foldr : ('a * 'b -> 'b) -> 'b -> 'a fifo -> 'b
- val q = empty;
val q = Q {front=[],rear=[]} : 'a fifo
- isEmpty q;
val it = true : bool
- val q' = enqueue (q, 1);
val q' = Q {front=[],rear=[1]} : int fifo
- isEmpty q';
val it = false : bool
- val q'' = List.foldl (fn (x, q) => enqueue (q, x)) q' [2, 3, 4];
val q'' = Q {front=[],rear=[4,3,2,1]} : int fifo
- peek q'';
val it = SOME 1 : int option
- length q'';
val it = 4 : int
- contents q'';
val it = [1,2,3,4] : int list
- val (q''', v) = dequeue q'';
val q''' = Q {front=[2,3,4],rear=[]} : int fifo
val v = 1 : int
- val (q'''', v') = dequeue q''';
val q'''' = Q {front=[3,4],rear=[]} : int fifo
val v' = 2 : int
- val (q''''', v'') = dequeue q'''';
val q''''' = Q {front=[4],rear=[]} : int fifo
val v'' = 3 : int
- val (q'''''', v''') = dequeue q''''';
val q'''''' = Q {front=[],rear=[]} : int fifo
val v''' = 4 : int
- isEmpty q'''''';
val it = true : bool
