type Printable =
  abstract member Print : unit -> unit

type Point(?x, ?y) =
  member t.x = defaultArg x 0.0
  member t.y = defaultArg y 0.0
  interface Printable with
     member t.Print() = printfn "Point(x:%f, y:%f)" t.x t.y

type Circle(?center, ?radius) =
  member t.center = defaultArg center (new Point())
  member t.radius = defaultArg radius 1.0
  interface Printable with
    member t.Print() =
      printfn "Circle(x:%f, y:%f, r:%f)" t.center.x t.center.y t.radius
