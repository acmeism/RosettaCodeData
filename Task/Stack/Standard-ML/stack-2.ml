structure Stack :> STACK =
struct
    type 'a stack = 'a list
    exception EmptyStack

    val empty = []

    fun isEmpty st = null st

    fun push (x, st) = x::st

    fun pop []      = raise EmptyStack
      | pop (x::st) = st

    fun top []      = raise EmptyStack
      | top (x::st) = x

    fun popTop st = (pop st, top st)

    fun map f st = List.map f st
    fun app f st = List.app f st
end
