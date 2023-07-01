type T() =
  // expose protected MemberwiseClone method (and downcast the result)
  member x.Clone() = x.MemberwiseClone() :?> T
  // virtual method Print with default implementation
  abstract Print : unit -> unit
  default x.Print() = printfn "I'm a T!"

type S() =
  inherit T()
  override x.Print() = printfn "I'm an S!"

let s = new S()
let s2 = s.Clone()  // the static type of s2 is T, but it "points" to an S
s2.Print() // prints "I'm an S!"
