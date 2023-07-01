[<AbstractClass>]
type Bird() =
  // an abstract (=virtual) method with default impl.
  abstract Move : unit -> unit
  default x.Move() = printfn "flying"
  // a pure virtual method
  abstract Sing: unit -> string

type Blackbird() =
  inherit Bird()
  override x.Sing() = "tra-la-la"

type Ostrich() =
  inherit Bird()
  override x.Move() = printfn "walking"
  override x.Sing() = "hiss hiss!"
