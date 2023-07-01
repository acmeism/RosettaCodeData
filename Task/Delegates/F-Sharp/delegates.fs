type Delegator() =
  let defaultOperation() = "default implementation"
  let mutable del = null

  // write-only property "Delegate"
  member x.Delegate with set(d:obj) = del <- d

  member x.operation() =
    if del = null then
      defaultOperation()
    else
      match del.GetType().GetMethod("thing", [||]) with
      | null -> defaultOperation()
      | thing -> thing.Invoke(del, [||]) :?> string

type Delegate() =
  member x.thing() = "delegate implementation"

let d = new Delegator()
assert (d.operation() = "default implementation")

d.Delegate <- "A delegate may be any object"
assert (d.operation() = "default implementation")

d.Delegate <- new Delegate()
assert (d.operation() = "delegate implementation")
