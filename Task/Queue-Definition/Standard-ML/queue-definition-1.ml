signature QUEUE =
sig
  type 'a queue

  val empty_queue: 'a queue

  exception Empty

  val enq: 'a queue -> 'a -> 'a queue
  val deq: 'a queue -> ('a * 'a queue)
  val empty: 'a queue -> bool
end;
