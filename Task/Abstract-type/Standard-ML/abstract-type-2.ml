signature LIST_QUEUE = sig
  type 'a queue = 'a list
  val empty : 'a queue
  val enqueue : 'a -> 'a queue -> 'a queue
  val dequeue : 'a queue -> ('a * 'a queue) option
end
