signature STACK =
sig
    type 'a stack
    exception EmptyStack

    val empty : 'a stack
    val isEmpty : 'a stack -> bool

    val push : ('a * 'a stack) -> 'a stack
    val pop  : 'a stack -> 'a stack
    val top  : 'a stack -> 'a
    val popTop : 'a stack -> 'a stack * 'a

    val map : ('a -> 'b) -> 'a stack -> 'b stack
    val app : ('a -> unit) -> 'a stack -> unit
end
