// A function taking and returning nothing (unit).
val noArgs : unit -> unit
// A function taking two integers, and returning an integer.
val twoArgs : int -> int -> int
// A function taking a ParamPack array of ints, and returning an int. The ParamPack
// attribute is not included in the signature.
val varArgs : int [] -> int
// A function taking an int and a ParamPack array of ints, and returning an
// object of the same type.
val atLeastOnArg : int -> int [] -> int
// A function taking an int Option, and returning an int.
val optionalArg : Option<int> -> int

// Named arguments and the other form of optional arguments are only available on
// methods.
type methodClass =
  class
    // A method taking an int named x, and returning an int.
    member NamedArg : x:int -> int
    // A method taking two optional ints in a tuple, and returning an int. The
    //optional arguments must be tupled.
    member OptionalArgs : ?x:int * ?y:int -> int
  end
