structure Queue:> QUEUE =
struct
  type 'a queue = 'a list

  val empty_queue = nil

  exception Empty

  fun enq q x = q @ [x]

  fun deq nil = raise Empty
  |   deq (x::q) = (x, q)

  fun empty nil = true
  |   empty _ = false
end;
