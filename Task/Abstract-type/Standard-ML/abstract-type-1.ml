signature QUEUE = sig
  type 'a queue
  val empty : 'a queue
  val enqueue : 'a -> 'a queue -> 'a queue
  val dequeue : 'a queue -> ('a * 'a queue) option
end
